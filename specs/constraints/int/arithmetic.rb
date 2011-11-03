require File.dirname(__FILE__) + '/../property_helper'

class ArithmeticSampleProblem
  include Gecode::Mixin

  attr :var
  attr :var2
  
  def initialize
    @var = int_var(-9..9)
    @var2 = int_var(0..9)
    branch_on wrap_enum([@var, @var2])
  end
end

describe Gecode::Int::Arithmetic, ' (abs)' do
  before do
    @model = ArithmeticSampleProblem.new
    @var = @model.var

    @property_types = [:int]
    @select_property = lambda do |int|
      int.abs
    end
    @selected_property = @var.abs
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the absolute value' do
    @var.must < 0
    @var.abs.must == 5
    @model.solve!.var.value.should == -5
  end

  it 'should translate into an abs constraint' do
    Gecode::Raw.should_receive(:abs)
    @var.abs.must == 5
    @model.solve!
  end

  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end

describe Gecode::Int::Arithmetic, ' (multiplication)' do
  before do
    @model = ArithmeticSampleProblem.new
    @var = @model.var
    @var2 = @model.var2

    @property_types = [:int, :int]
    @select_property = lambda do |int1, int2|
      int1 * int2
    end
    @selected_property = @var * @var2
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the value of the multiplication' do
    (@var * @var2).must == 56
    sol = @model.solve!
    [sol.var.value, sol.var2.value].sort.should == [7, 8]
  end

  it 'should translate into a mult constraint' do
    Gecode::Raw.should_receive(:mult)
    (@var * @var2).must == 56
    @model.solve!
  end
  
  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end

describe Gecode::Int::Arithmetic, ' (squared)' do
  before do
    @model = ArithmeticSampleProblem.new
    @var = @model.var
    
    @property_types = [:int]
    @select_property = lambda do |int|
      int.squared
    end
    @selected_property = @var.squared
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the value of the variable squared' do
    @var.squared.must == 9
    sol = @model.solve!
    sol.var.value.abs.should == 3
  end

  it 'should translate into a squared constraint' do
    Gecode::Raw.should_receive(:sqr)
    @var.squared.must == 4
    @model.solve!
  end
  
  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end

describe Gecode::Int::Arithmetic, ' (square root)' do
  before do
    @model = ArithmeticSampleProblem.new
    @var = @model.var

    @property_types = [:int]
    @select_property = lambda do |int|
      int.sqrt
    end
    @selected_property = @var.sqrt
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the square root of the variable' do
    @var.square_root.must == 3
    sol = @model.solve!
    Math.sqrt(sol.var.value).floor.should == 3
  end
  
  it 'should constrain the square root of the variable (2)' do
    @var.square_root.must == 0
    sol = @model.solve!
    Math.sqrt(sol.var.value).floor.should == 0
  end
  
  it 'should constrain the square root of the variable (3)' do
    @var.must < 0
    @var.square_root.must == 0
    lambda{ @model.solve! }.should raise_error(Gecode::NoSolutionError)
  end
  
  it 'should round down the square root' do
    @var.must > 4
    @var.square_root.must == 2
    sol = @model.solve!
    sol.var.value.should be_between(5,8)
  end
  
  it 'should translate into a square root constraint' do
    Gecode::Raw.should_receive(:sqrt)
    @var.sqrt.must == 2
    @model.solve!
  end

  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end

