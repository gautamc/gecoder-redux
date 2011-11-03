require File.dirname(__FILE__) + '/../spec_helper'

# Every constraint should have a spec that specs the following:
#
# * An example where the constraint is used to constrain a sample
# problem (and one for negation if deemed necessary).
# * should_behave_like [non-reifiable|reifiable] constraint (possibly
# indirect).
# * Those constraints that do not support negation must
# should_behave_like 'non-negatable constraint'
#


# These specs assume that the following variables are defined:
# [@expect]          A proc that creates an expectation corresponding to
#                    constraint. It should take three parameter. The
#                    first is an array of operands of types specified by
#                    @types. The second is whether or not the constraint
#                    should be negated. The third is a hash that can
#                    have values for the keys :icl (ICL_*), :pk (PK_*),
#                    and :bool (bound reification variable). Any values
#                    not provided are assumed to be default values (nil
#                    in the case of :bool).
# [@invoke]          A proc that invokes the constraint to be tested, It 
#                    should have arity arity(@types) + 1. The first
#                    parameter is a constraint receiver (type decided by 
#                    @types). The next arity(@types)-1 parameters are 
#                    given operands of types specified by @types. The
#                    last parameter is a hash of options (with at most
#                    the keys :strength, :kind and :reify)..
# [@types]           An array of symbols signaling what types of
#                    arguments @ accepts. The symbols
#                    must be one of: :int, :bool, :set, :int_enum,
#                    :bool_enum, :set_enum, :fixnum_enum.
# [@model]           The model instance that contains the aspects being tested.

def expect(variables, options)
  bool = options[:bool]
  bool = @model.allow_space_access{ bool.bind } unless bool.nil?
  args = @model.allow_space_access do 
    variables.map do |var| 
      if var.respond_to? :bind
        var.bind
      else
        var.bind_array
      end
    end
  end
  args << [options[:icl] || Gecode::Raw::ICL_DEF,
           options[:pk]  || Gecode::Raw::PK_DEF]
  args << bool
  @expect.call(*args)
end

def invoke(operands, options)
  base_op = operands.first
  if options.delete(:negate)
    receiver = base_op.must_not
  else
    receiver = base_op.must
  end
  args = ([receiver] + operands[1..-1]) << options
  @invoke.call(*args)
end

describe 'reifiable constraint', :shared => true do
  it_should_behave_like 'constraint with default options'
  it_should_behave_like 'constraint with reification option'
  it_should_behave_like 'constraint'
end

describe 'non-reifiable constraint', :shared => true do
  it 'should raise errors if reification is used' do
    operands, variables = produce_general_arguments(@types)
    lambda do 
      invoke(operands, :reify => @model.bool_var)
    end.should raise_error(ArgumentError)
  end

  it_should_behave_like 'constraint with default options'
  it_should_behave_like 'constraint'
end

describe 'non-negatable constraint', :shared => true do
  it 'should raise errors if negation is used' do
    operands, variables = produce_general_arguments(@types)
    lambda do 
      invoke(operands, :negate => true)
    end.should raise_error(Gecode::MissingConstraintError)
  end
end

describe 'constraint', :shared => true do
  it 'should raise errors if parameters of the incorrect type are given' do
    operands, variables = produce_general_arguments(@types)
    (1...operands.size).each do |i|
      bogus_operands = operands.clone
      bogus_operands[i] = Object.new
      lambda do
        invoke(bogus_operands, {})
      end.should raise_error(TypeError)
    end
  end
end

describe 'constraint with reification option', :shared => true do
  it 'should translate reification' do
    operands, variables = produce_general_arguments(@types)
    var = @model.bool_var
    expect(variables, :bool => var)
    invoke(operands, :reify => var)
  end

  it 'should translate reification with arbitrary bool operand' do
    operands, variables = produce_general_arguments(@types)
    op, bool_var = general_bool_operand(@model)
    expect(variables, :bool => bool_var)
    invoke(operands, :reify => op)
  end
  
  it 'should raise errors for reification variables of incorrect type' do
    operands, variables = produce_general_arguments(@types)
    lambda do 
      invoke(operands, :reify => 'foo')
    end.should raise_error(TypeError)
  end
end

describe 'constraint with default options', :shared => true do
  it 'should raise errors for unrecognized options' do
    operands, variables = produce_general_arguments(@types)
    lambda do 
      invoke(operands, :does_not_exist => :foo) 
    end.should raise_error(ArgumentError)
  end

  it_should_behave_like 'constraint with strength option'
  it_should_behave_like 'constraint with kind option'
end

describe 'constraint with strength option', :shared => true do
  { :default  => Gecode::Raw::ICL_DEF,
    :value    => Gecode::Raw::ICL_VAL,
    :bounds   => Gecode::Raw::ICL_BND,
    :domain   => Gecode::Raw::ICL_DOM
  }.each_pair do |name, gecode_value|
    it "should translate propagation strength #{name}" do
      operands, variables = produce_general_arguments(@types)
      expect(variables, :icl => gecode_value)
      invoke(operands, :strength => name)
    end
  end
  
  it 'should default to using default as propagation strength' do
    operands, variables = produce_general_arguments(@types)
    expect(variables, {})
    invoke(operands, {})
  end
  
  it 'should raise errors for unrecognized propagation strengths' do
    operands, variables = produce_general_arguments(@types)
    lambda do 
      invoke(operands, :strength => :does_not_exist) 
    end.should raise_error(ArgumentError)
  end
end

describe 'constraint with kind option', :shared => true do
  { :default  => Gecode::Raw::PK_DEF,
    :speed    => Gecode::Raw::PK_SPEED,
    :memory   => Gecode::Raw::PK_MEMORY
  }.each_pair do |name, gecode_value|
    it "should translate propagation kind #{name}" do
      operands, variables = produce_general_arguments(@types)
      expect(variables, :pk => gecode_value)
      invoke(operands, :kind => name)
    end
  end
  
  it 'should default to using default as propagation kind' do
    operands, variables = produce_general_arguments(@types)
    expect(variables, {})
    invoke(operands, {})
  end
  
  it 'should raise errors for unrecognized propagation kinds' do
    operands, variables = produce_general_arguments(@types)
    lambda do 
      invoke(operands, :kind => :does_not_exist)
    end.should raise_error(ArgumentError)
  end
end

describe 'set constraint', :shared => true do
  it 'should not accept strength option' do
    operands, variables = produce_general_arguments(@types)
    lambda do 
      invoke(operands, :strength => :default)
    end.should raise_error(ArgumentError)
  end
  
  it 'should not accept kind option' do
    operands, variables = produce_general_arguments(@types)
    lambda do 
      invoke(operands, :kind => :default)
    end.should raise_error(ArgumentError)
  end
  
  it 'should raise errors for unrecognized options' do
    operands, variables = produce_general_arguments(@types)
    lambda do 
      invoke(operands, :does_not_exist => :foo) 
    end.should raise_error(ArgumentError)
  end

  it_should_behave_like 'constraint'
end

describe 'non-reifiable set constraint', :shared => true do
  it 'should not accept reification option' do
    bool = @model.bool_var
    operands, variables = produce_general_arguments(@types)
    lambda do 
      invoke(operands, :reify => bool)
    end.should raise_error(ArgumentError)
  end
  
  it_should_behave_like 'set constraint'
end

describe 'reifiable set constraint', :shared => true do
  it_should_behave_like 'set constraint'
  it_should_behave_like 'constraint with reification option'
end
