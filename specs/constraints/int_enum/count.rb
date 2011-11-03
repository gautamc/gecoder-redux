require File.dirname(__FILE__) + '/../property_helper'

class CountSampleProblem
  include Gecode::Mixin

  attr :list
  attr :element
  attr :target
  
  def initialize
    @list = int_var_array(4, 0..3)
    @element = int_var(0..3)
    @target = int_var(0..4)
    branch_on @list
    branch_on @element
  end
end

describe Gecode::IntEnum::Count, ' (with int var)' do
  before do
    @model = CountSampleProblem.new
    @list = @model.list
    @element = @model.element
    @target = @model.target
    
    # For int operand producing property spec.
    @property_types = [:int_enum, :int]
    @select_property = lambda do |int_enum, int|
      int_enum.count(int)
    end
    @selected_property = @list.count(@element)
    @constraint_class = 
      Gecode::IntEnum::Count::CountConstraint
  end

  it 'should constrain the count' do
    @list.count(@element).must == 2
    @model.solve!
    @list.values.map{ |x| x == @element.value }.inject(0) do |sum, b| 
      sum += b ? 1 : 0
    end.should == 2
  end
  
  it_should_behave_like(
    'property that produces int operand by short circuiting relations')
end

describe Gecode::IntEnum::Count, ' (with fixnum)' do
  before do
    @model = CountSampleProblem.new
    @list = @model.list
    @target = @model.target
    
    # For int operand producing property spec.
    @property_types = [:int_enum]
    @select_property = lambda do |int_enum|
      int_enum.count(1)
    end
    @selected_property = @list.count(1)
    @constraint_class = 
      Gecode::IntEnum::Count::CountConstraint
  end

  it 'should constrain the count' do
    @list.count(1).must == 2
    @model.solve!
    @list.values.map{ |x| x == 1 }.inject(0) do |sum, b| 
      sum += b ? 1 : 0
    end.should == 2
  end
  
  it_should_behave_like(
    'property that produces int operand by short circuiting relations')
end
