require File.dirname(__FILE__) + '/../constraint_helper'

# Assumes that @variables, @expected_array and @tuples are defined.
describe 'bool tuple constraint', :shared => true do
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

describe Gecode::BoolEnum::Extensional, ' (tuple constraint)' do
  before do
    @model = Gecode::Model.new
    @tuples = [[true, false, true], [false, false, true]]
    @variables = @bools = @model.bool_var_array(3)
    @model.branch_on @bools
    
    @types = [:bool_enum]
    @invoke = lambda do |receiver, hash| 
      receiver.in([[true, false, true, false, true], 
                  [false, true, true, true, true]], hash)
      @model.solve!
    end
    @expect = lambda do |var, opts, reif_var|
      Gecode::Raw.should_receive(:extensional).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var, an_instance_of(Gecode::Raw::TupleSet), *opts)
    end
  end
  
  it 'should constrain the domain of all variables' do
    @bools.must_be.in @tuples
    
    found_solutions = []
    @model.each_solution do |m|
      found_solutions << @bools.values
    end
    
    found_solutions.size.should == 2
    (found_solutions - @tuples).should be_empty
  end
  
  it 'should raise error if the right hand side is not an enumeration' do
    lambda{ @bools.must_be.in true }.should raise_error(TypeError)
  end
  
  it 'should raise error if the right hand side does not contain tuples' do
    lambda{ @bools.must_be.in [true, false] }.should raise_error(TypeError)
  end
  
  it_should_behave_like 'bool tuple constraint'
  it_should_behave_like 'non-reifiable constraint'
end


# Assumes that @variables, @expected_array, @value1, @value2 (must not
# equal @value1) and @regexp are defined. 
describe 'bool regular expression constraint', :shared => true do
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

describe Gecode::BoolEnum::Extensional, ' (regexp constraint)' do
  before do
    @model = Gecode::Model.new
    @variables = @bools = @model.bool_var_array(3)
    @model.branch_on @bools
    @expected_array = an_instance_of Gecode::Raw::BoolVarArray
    @value1 = true
    @value2 = false
    @regexp = [true, @model.any(true, false), @model.at_most_once(true)]

    @types = [:bool_enum]
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
    @bools.must.match [@model.repeat(@model.any(true, false))]
    @bools[0].must_be.true
    @bools[1].must_be.false
    @model.solve!.should_not be_nil
    @bools[0].value.should be_true
    @bools[1].value.should be_false
  end

  it 'should handle the any operator with nested expressions' do
    @bools.must.match [@model.any(@model.at_least_once(true), [false])]
    @model.solve!.should_not be_nil
    @bools.values.should == [true, true, true]
  end

  it_should_behave_like 'bool regular expression constraint'
  it_should_behave_like 'non-reifiable constraint'
end
