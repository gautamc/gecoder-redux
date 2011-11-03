require File.dirname(__FILE__) + '/../constraint_helper'

# This is neither an operand or a constraint spec. It is mostly a sanity
# check.

class LinearSampleProblem
  include Gecode::Mixin

  attr :x
  attr :y
  attr :z
  
  def initialize(x_dom, y_dom, z_dom)
    @x = self.int_var(x_dom)
    @y = self.int_var(y_dom)
    @z = self.int_var(z_dom)
    branch_on wrap_enum([@x, @y, @z])
  end
end

describe Gecode::Int::Linear do
  before do
    @x_dom = 0..2
    @y_dom = -3..3
    @z_dom = 0..10
    @model = LinearSampleProblem.new(@x_dom, @y_dom, @z_dom)
    @x = @model.x
    @y = @model.y
    @z = @model.z
    @operand = @x + @y
  end

  it 'should handle addition with a variable' do
    (@x + @y).must == 0
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    (x + y).should be_zero
  end

  it 'should handle reification (1)' do
    bool = @model.bool_var
    (@x + @y).must.equal(0, :reify => bool)
    bool.must_be.false
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    (x + y).should_not be_zero
  end

  it 'should handle reification (2)' do
    bool = @model.bool_var
    (@x + @y).must.equal(0, :reify => bool)
    bool.must_be.true
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    (x + y).should be_zero
  end
  
  it 'should handle addition with multiple variables' do
    (@x + @y + @z).must == 0
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    z = sol.z.value
    (x + y + z).should be_zero
  end
  
  it 'should handle subtraction with a variable' do
    (@x - @y).must == 0
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    (x - y).should be_zero
  end
  
  it 'should handle non-zero constants as right hand side' do
    (@x + @y).must == 1
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    (x + y).should equal(1)
  end
  
  it 'should handle variables as right hand side' do
    (@x + @y).must == @z
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    z = sol.z.value
    (x + y).should equal(z)
  end
  
  it 'should handle linear expressions as right hand side' do
    (@x + @y).must == @z + @y
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    z = sol.z.value
    (x + y).should equal(z + y)
  end
  
  it 'should handle linear expressions as right hand side with variable as left hand side' do
    @x.must == @z + @y
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    z = sol.z.value
    x.should equal(z + y)
  end

  it 'should raise error on invalid right hand sides' do
    lambda{ ((@x + @y).must == 'z') }.should raise_error(TypeError) 
  end
  
  it 'should handle coefficients other than 1' do
    (@x * 2 + @y).must == 0
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    (2*x + y).should equal(0)
  end
  
  it 'should handle addition with constants' do
    (@y + 2).must == 1
    sol = @model.solve!
    y = sol.y.value
    (y + 2).should equal(1)
  end
  
  it 'should handle subtraction with a constant' do
    (@x - 2).must == 0
    sol = @model.solve!
    x = sol.x.value
    (x - 2).should be_zero
  end
  
  it 'should a single variable as left hande side' do
    @x.must == @y + @z
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    z = sol.z.value
    x.should equal(y + z)
  end
  
  it 'should handle parenthesis' do
    (@x - (@y + @z)).must == 1
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    z = sol.z.value
    (x - (y + z)).should equal(1)
  end
  
  it 'should handle multiplication of parenthesis' do
    (((@x + @y*10)*10 + @z)*10).must == 0
    sol = @model.solve!
    x = sol.x.value
    y = sol.y.value
    z = sol.z.value
    (((x + y*10)*10 + z)*10).should equal(0)
  end
  
  relations = ['>', '>=', '<', '<=', '==']
  
  relations.each do |relation|
    it "should handle #{relation} with constant integers" do
      (@x + @y).must.send(relation, 1)
      sol = @model.solve!
      sol.should_not be_nil
      (sol.x.value + sol.y.value).should.send(relation, 1)
    end
  end
  
  relations.each do |relation|
    it "should handle negated #{relation} with constant integers" do
      (@x + @y).must_not.send(relation, 1)
      sol = @model.solve!
      sol.should_not be_nil
      (sol.x.value + sol.y.value).should_not.send(relation, 1)
    end
  end
end
