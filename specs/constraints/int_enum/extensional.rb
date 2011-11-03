require File.dirname(__FILE__) + '/../constraint_helper'

# Assumes that @variables, @expected_array and @tuples are defined.
describe 'int tuple constraint', :shared => true do
  it 'should not allow negation' do
    lambda do 
      @variables.must_not_be.in @tuples
    end.should raise_error(Gecode::MissingConstraintError)
  end
  
  it 'should not allow empty tuples' do
    lambda do 
      @variables.must_be.in []
    end.should raise_error(ArgumentError)
  end
  
  it 'should not allow tuples of sizes other than the number of variables' do
    lambda do 
      @variables.must_be.in([@tuples.first * 2])
    end.should raise_error(ArgumentError)
  end
  
  it 'should raise error if the right hand side does not contain tuples of correct type' do
    lambda do 
      size = @variables.size
      @variables.must_be.in ['h'*size, 'i'*size] 
    end.should raise_error(TypeError)
  end
end

describe Gecode::IntEnum::Extensional, ' (tuple constraint)' do
  before do
    @model = Gecode::Model.new
    @tuples = [[1,7], [5,1]]
    @variables = @digits = @model.int_var_array(2, 0..9)
    @model.branch_on @digits

    @types = [:int_enum]
    @invoke = lambda do |receiver, hash| 
      receiver.in([[1, 7, 5, 3, 0], [8, 9, 9, 9, 0]], hash)
      @model.solve!
    end
    @expect = lambda do |var, opts, reif_var|
      Gecode::Raw.should_receive(:extensional).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var, an_instance_of(Gecode::Raw::TupleSet), *opts)
    end
  end
  
  it 'should constrain the domain of all variables' do
    @digits.must_be.in @tuples
    
    found_solutions = []
    @model.each_solution do |m|
      found_solutions << @digits.values
    end
    
    found_solutions.size.should == 2
    (found_solutions - @tuples).should be_empty
  end
  
  it 'should raise error if the right hand side is not an enumeration' do
    lambda{ @digits.must_be.in 4711 }.should raise_error(TypeError)
  end
  
  it 'should raise error if the right hand side does not contain tuples' do
    lambda{ @digits.must_be.in [17, 4711] }.should raise_error(TypeError)
  end
  
  it_should_behave_like 'int tuple constraint'
  it_should_behave_like 'non-reifiable constraint'
end

# Assumes that @variables, @expected_array, @value1, @value2 (must not
# equal @value1) and @regexp are defined. 
describe 'int regular expression constraint', :shared => true do
  it 'should handle values grouped in a single array' do
    @variables.must.match [@value1, @value2, @value1]
    @model.solve!.should_not be_nil
    @variables.values.should == [@value1, @value2, @value1]
  end

  it 'should allow nested groups of values' do
    @variables.must.match [@value1, [@value2, [@value1]]]
    @model.solve!.should_not be_nil
    @variables.values.should == [@value1, @value2, @value1]
  end
  
  it 'should handle the repeat operation' do
    @variables.must.match [@value1, @model.repeat([@value2], 1, 2)]
    @model.solve!.should_not be_nil
    @variables.values.should == [@value1, @value2, @value2]
  end

  it 'should handle repeat operations that do not encase constant values in arrays' do
    @variables.must.match [@value1, @model.repeat(@value2, 1, 2)]
    @model.solve!.should_not be_nil
    @variables.values.should == [@value1, @value2, @value2]
  end

  it 'should handle nested repeat operations' do
    @variables.must.match [[@model.repeat(@model.repeat([@value2], 1, 3), 1, 2)]]
    @model.solve!.should_not be_nil
    @variables.values.should == [@value2, @value2, @value2]
  end

  it 'should handle nested repeat operations (2)' do
    @variables.must.match [[@model.repeat([@model.repeat(@value2, 1, 3)], 1, 2)]]
    @model.solve!.should_not be_nil
    @variables.values.should == [@value2, @value2, @value2]
  end

  it 'should interpret the repeat operation with the last argument omitted as only giving a lower bound' do
    @variables.must.match [@value1, @model.repeat([@value2], 1)]
    @model.solve!.should_not be_nil
    @variables.values.should == [@value1, @value2, @value2]
  end

  it 'should interpret the repeat operation with all but the first argument omitted as not giving any bound' do
    @variables.must.match [@model.repeat(@value2), @value1, @value1, @value1]
    @model.solve!.should_not be_nil
    @variables.values.should == [@value1, @value1, @value1]
  end

  it 'should interpret the repeat operation with all but the first argument omitted as not giving any bound (2)' do
    @variables.must.match [@model.repeat(@value2)]
    @model.solve!.should_not be_nil
    @variables.values.should == [@value2, @value2, @value2]
  end

  it 'should translate at_most_once(reg) to repeat(reg, 0, 1)' do
    @model.should_receive(:repeat).once.with([@value1], 0, 1)
    @model.at_most_once [@value1]
  end

  it 'should translate at_least_once(reg) to repeat(reg, 1)' do
    @model.should_receive(:repeat).once.with([@value1], 1)
    @model.at_least_once [@value1]
  end

  it 'should raise error if the right hand side is not an enumeration' do
    lambda do 
      @variables.must.match Object.new
    end.should raise_error(TypeError)
  end
  
  it 'should raise error if the right hand side does not a regexp of the right type' do
    lambda do 
      @variables.must.match [@value1, 'foo'] 
    end.should raise_error(TypeError)
  end

  it 'should raise error if the right hand side contains a nested element of an incorrect type' do
    lambda do 
      @variables.must.match [@value1, [@value2, 'foo']] 
    end.should raise_error(TypeError)
  end

  it 'should raise error if the repeat operation is given arguments of incorrect type (2)' do
    lambda do 
      @variables.must.match @model.repeat(@value1, [0], 1)
    end.should raise_error(TypeError)
  end

  it 'should raise error if the repeat operation is given arguments of incorrect type (3)' do
    lambda do 
      @variables.must.match @model.repeat(@value1, 0, [1])
    end.should raise_error(TypeError)
  end
  
  it 'should raise error if the repeat operation is given arguments of incorrect type' do
    lambda do 
      @variables.must.match @model.repeat('foo', 0, 1)
    end.should raise_error(TypeError)
  end

  it 'should not allow negation' do
    lambda do 
      @variables.must_not.match @regexp
    end.should raise_error(Gecode::MissingConstraintError)
  end
end

describe Gecode::IntEnum::Extensional, ' (regexp constraint)' do
  before do
    @model = Gecode::Model.new
    @variables = @digits = @model.int_var_array(3, 0..9)
    @model.branch_on @digits
    @expected_array = an_instance_of Gecode::Raw::IntVarArray
    @value1 = 3
    @value2 = 5
    @regexp = [1, @model.any(3, 4), @model.at_most_once(5)]

    @types = [:int_enum]
    @invoke = lambda do |receiver, hash| 
      receiver.match(@regexp, hash)
      @model.solve!
    end
    @expect = lambda do |var, opts, reif_var|
      Gecode::Raw.should_receive(:extensional).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var, an_instance_of(Gecode::Raw::REG), *opts)
    end
  end

  it 'should handle the any operation' do
    @digits.must.match [1, @model.any(1, 2, 3), 3]
    @model.solve!.should_not be_nil
    values = @digits.values
    values.size.should == 3 
    values.should == values.sort
  end

  it 'should handle the any operator with nested expressions' do
    @digits.must.match [1, @model.any(@model.at_least_once(2), [3, 5])]
    @digits[2].must < 4
    @model.solve!.should_not be_nil
    @digits.values.should == [1,2,2]
  end

  it_should_behave_like 'int regular expression constraint'
  it_should_behave_like 'non-reifiable constraint'
end

