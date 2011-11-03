require File.dirname(__FILE__) + '/../property_helper'

class LinearPropertySampleProblem
  include Gecode::Mixin

  attr :x
  attr :y
  attr :z
  
  def initialize
    @x = self.int_var(0..2)
    @y = self.int_var(-3..3)
    @z = self.int_var(0..10)
    branch_on wrap_enum([@x, @y, @z])
  end
end

describe Gecode::Int::Linear, ' (+ property)' do
  before do
    @model = LinearPropertySampleProblem.new
    @x = @model.x
    @y = @model.y
    @z = @model.z

    # For int operand producing property spec.
    @property_types = [:int, :int]
    @select_property = lambda do |int1, int2|
      int1 + int2
    end
    @selected_property = @x + @y
    @constraint_class = 
      Gecode::Int::Linear::LinearRelationConstraint
  end

  it 'should constrain the sum' do
    (@x + @y).must == 5
    @model.solve!
    (@x.value + @y.value).should == 5
  end

  it_should_behave_like(
    'property that produces int operand by short circuiting relations')
end

describe Gecode::Int::Linear, ' (- property)' do
  before do
    @model = LinearPropertySampleProblem.new
    @x = @model.x
    @y = @model.y
    @z = @model.z

    # For int operand producing property spec.
    @property_types = [:int, :int]
    @select_property = lambda do |int1, int2|
      int1 - int2
    end
    @selected_property = @x - @y
    @constraint_class = 
      Gecode::Int::Linear::LinearRelationConstraint
  end

  it 'should constrain the difference' do
    (@x - @y).must == 1
    @model.solve!
    (@x.value - @y.value).should == 1
  end

  it_should_behave_like(
    'property that produces int operand by short circuiting relations')
end

describe Gecode::Int::Linear, ' (* property)' do
  before do
    @model = LinearPropertySampleProblem.new
    @x = @model.x
    @y = @model.y
    @z = @model.z

    # For int operand producing property spec.
    @property_types = [:int]
    @select_property = lambda do |int|
      int * 17
    end
    @selected_property = @x * 2
    @constraint_class = 
      Gecode::Int::Linear::LinearRelationConstraint
  end

  it 'should constrain the value times a constant' do
    (@x * 2).must == 4
    @model.solve!
    (@x.value * 2).should == 4
  end

  it_should_behave_like(
    'property that produces int operand by short circuiting relations')
end


