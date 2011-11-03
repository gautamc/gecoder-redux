require File.dirname(__FILE__) + '/../property_helper'

describe Gecode::Set::Cardinality, ' (property)' do
  before do
    @model = Gecode::Model.new
    @set = @model.set_var([], 0..10)
    @var = @model.int_var(0..11)
    @model.branch_on @set
    @model.branch_on @var
    
    @property_types = [:set]
    @select_property = lambda do |set|
      set.size
    end
    @selected_property = @set.size
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the cardinality of a set' do
    @set.size.must == @var
    @model.solve!
    @set.value.size.should == @var.value
  end
  
  it 'should constrain the cardinality of a set (2)' do
    @set.size.must == 2
    @model.solve!.should_not be_nil
    @set.value.size.should == 2
  end

  it 'should constrain the cardinality of a set (3)' do
    @set.size.must == @var
    @var.must == 2
    @model.solve!
    @set.value.size.should == 2
  end

  it 'should translate into a cardinality constraint' do
    Gecode::Raw.should_receive(:cardinality)
    @set.size.must == @var
    @model.solve!
  end

  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end
