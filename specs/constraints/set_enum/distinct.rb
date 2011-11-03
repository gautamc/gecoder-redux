require File.dirname(__FILE__) + '/../constraint_helper'

class SetEnumDistinctSampleProblem
  include Gecode::Mixin

  attr :vars
  attr :sets
  
  def initialize
    @vars = int_var_array(2, 1)
    @sets = set_var_array(2, [], 0..2)
    branch_on @sets
  end
end

describe Gecode::SetEnum::Distinct, ' (at most one)' do
  before do
    @model = SetEnumDistinctSampleProblem.new
    @sets = @model.sets
    @size = 2
    
    @types = [:set_enum]
    @invoke = lambda do |receiver, hash| 
      receiver.at_most_share_one_element hash.update(:size => @size)
      @model.solve!
    end
    @expect = lambda do |var, opts, reif_var|
      Gecode::Raw.should_receive(:atmostOne).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var, @size)
    end
  end

  it 'should translate into a atmostOne constraint' do
    Gecode::Raw.should_receive(:atmostOne).once.with(
      an_instance_of(Gecode::Raw::Space), 
      an_instance_of(Gecode::Raw::SetVarArray), @size)
    @sets.must.at_most_share_one_element(:size => @size)
    @model.solve!
  end

  it 'should constrain sets to have at most one element in common' do
    @sets.must.at_most_share_one_element(:size => @size)
    @sets[0].must_not_be.superset_of 0
    solution = @model.solve!
    solution.should_not be_nil
    set1, set2 = solution.sets
    set1.value.size.should == @size
    set2.value.size.should == @size
    (set1.value.to_a & set2.value.to_a).size.should <= 1
  end

  it 'should raise error if :size is not specified' do
    lambda do
      @sets.must.at_most_share_one_element 
    end.should raise_error(ArgumentError)
  end
  
  it_should_behave_like 'non-reifiable set constraint'
  it_should_behave_like 'non-negatable constraint'
end
