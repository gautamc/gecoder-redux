require File.dirname(__FILE__) + '/../constraint_helper'

describe Gecode::Set::Cardinality, ' (constraint)' do
  before do
    @model = Gecode::Model.new
    @set = @model.set_var([], 0..10)
    @model.branch_on @model.wrap_enum([@set])
    @range = 1..2
    @three_dot_range = 1...2
    
    @invoke = lambda do |rhs| 
      @set.size.must_be.in(rhs) 
      @model.solve!
    end
    @expect = lambda do |rhs|
      @model.allow_space_access do
        Gecode::Raw.should_receive(:cardinality).once.with(
          an_instance_of(Gecode::Raw::Space), 
          an_instance_of(Gecode::Raw::SetVar), rhs.first, rhs.last)
      end
    end
  end
  
  it 'should translate cardinality constraints with ranges' do
    @expect.call(@range)
    @invoke.call(@range)
  end

  it 'should translate cardinality constraints with three dot range domains' do
    @expect.call(@three_dot_range)
    @invoke.call(@three_dot_range)
  end
  
  it 'should constrain the cardinality of a set' do
    @set.size.must_be.in @range
    @model.solve!
    @range.should include(@set.value.size)
  end
  
  it 'should raise error if the right hand side is not a range' do
    lambda{ @set.size.must_be.in 'hello' }.should raise_error(TypeError)
  end
  
  it 'should not shadow the integer variable domain constrain' do
    Gecode::Raw.should_receive(:dom).with(
      an_instance_of(Gecode::Raw::Space), 
      an_instance_of(Gecode::Raw::IntVar), 0, 11, Gecode::Raw::ICL_DEF, 
      Gecode::Raw::PK_DEF)
    Gecode::Raw.should_receive(:dom).with(
      an_instance_of(Gecode::Raw::Space), 
      an_instance_of(Gecode::Raw::IntVar), an_instance_of(Gecode::Raw::IntSet), 
      an_instance_of(Gecode::Raw::BoolVar), Gecode::Raw::ICL_DEF, 
      Gecode::Raw::PK_DEF)
    @set.size.must_not_be.in [1,3]
    @model.solve!
  end
end

