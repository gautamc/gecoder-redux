require File.dirname(__FILE__) + '/../property_helper'

class IntEnumArithmeticSampleProblem
  include Gecode::Mixin

  attr :numbers
  attr :var
  
  def initialize
    @numbers = int_var_array(4, 0..9)
    @var = int_var(-9..9)
    branch_on @numbers
    branch_on @var
  end
end

describe Gecode::IntEnum::Arithmetic, ' (max)' do
  before do
    @model = IntEnumArithmeticSampleProblem.new
    @numbers = @model.numbers
    @var = @model.var

    @property_types = [:int_enum]
    @select_property = lambda do |int_enum|
      int_enum.max
    end
    @selected_property = @numbers.max
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the maximum value' do
    @numbers.max.must > 5
    @model.solve!.numbers.values.max.should > 5
  end

  it 'should translate into a max constraint' do
    Gecode::Raw.should_receive(:max)
    @numbers.max.must == 5
    @model.solve!
  end
  
  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end

describe Gecode::IntEnum::Arithmetic, ' (min)' do
  before do
    @model = IntEnumArithmeticSampleProblem.new
    @numbers = @model.numbers
    @var = @model.var

    @property_types = [:int_enum]
    @select_property = lambda do |int_enum|
      int_enum.min
    end
    @selected_property = @numbers.min
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the minimum value' do
    @numbers.min.must > 5
    @model.solve!.numbers.values.min.should > 5
  end

  it 'should translate into a min constraint' do
    Gecode::Raw.should_receive(:min)
    @numbers.min.must == 5
    @model.solve!
  end
  
  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end

