require File.dirname(__FILE__) + '/spec_helper'

describe Gecode::Mixin, ' (enum wrapping)' do
  before do
    @model = Gecode::Model.new
    @bool = @model.bool_var
    @int = @model.int_var(1..2)
    @set = @model.set_var([], 1..2)
  end

  it 'should only allow enumerables to be wrapped' do
    lambda do
      @model.wrap_enum(17) 
    end.should raise_error(TypeError)
  end

  it 'should allow enumerables of bool variables to be wrapped' do
    lambda do
      enum = [@bool]
      @model.wrap_enum(enum) 
    end.should_not raise_error
  end

  it 'should allow enumerables of bool operands to be wrapped' do
    lambda do
      enum = [@bool & @bool]
      @model.wrap_enum(enum) 
    end.should_not raise_error
  end
  
  it 'should allow enumerables of int variables to be wrapped' do
    lambda do
      enum = [@int]
      @model.wrap_enum(enum) 
    end.should_not raise_error
  end

  it 'should allow enumerables of int operands to be wrapped' do
    lambda do
      enum = [@int + @int]
      @model.wrap_enum(enum) 
    end.should_not raise_error
  end

  it 'should allow enumerables of set variables to be wrapped' do
    lambda do
      enum = [@set]
      @model.wrap_enum(enum) 
    end.should_not raise_error
  end

  it 'should allow enumerables of set operands to be wrapped' do
    lambda do
      enum = [@set.union(@set)]
      @model.wrap_enum(enum) 
    end.should_not raise_error
  end
  
  
  it 'should allow enumerables of fixnums to be wrapped' do
    lambda do
      enum = [17]
      @model.wrap_enum(enum) 
    end.should_not raise_error
  end
  
  it 'should not allow empty enumerables to be wrapped' do
    lambda do 
      @model.wrap_enum([]) 
    end.should raise_error(ArgumentError)
  end
  
  it 'should not allow wrapping a wrapped enumerable' do
    lambda do 
      enum = [@bool]
      @model.wrap_enum(@model.wrap_enum(enum)) 
    end.should raise_error(ArgumentError)
  end
  
  it 'should not allow enumerables without variables or fixnums to be wrapped' do
    lambda do 
      @model.wrap_enum(['foo']) 
    end.should raise_error(TypeError)
  end
  
  it 'should not allow enumerables with only some variables to be wrapped' do
    lambda do 
      enum = [@bool, 'foo']
      @model.wrap_enum(enum) 
    end.should raise_error(TypeError)
  end
  
  it 'should not allow enumerables with mixed types of variables to be wrapped' do
    lambda do 
      enum = [@bool, @int]
      @model.wrap_enum(enum) 
    end.should raise_error(TypeError)
  end
end

describe Gecode::IntEnumMethods do
  before do
    @model = Gecode::Model.new
    @int_enum = @model.int_var_array(3, 0..1)
  end
  
  it 'should convert to an int var array' do
    @model.allow_space_access do
      @int_enum.bind_array.should be_kind_of(Gecode::Raw::IntVarArray)
    end
  end
  
  it 'should compute the smallest domain range' do
    @int_enum.domain_range.should == (0..1)
    (@int_enum << @model.int_var(-4..4)).domain_range.should == (-4..4)
  end

  it 'should define #to_int_enum' do
    @int_enum.to_int_enum.should be_kind_of(
      Gecode::IntEnum::IntEnumOperand)
  end
end

describe Gecode::BoolEnumMethods do
  before do
    @model = Gecode::Model.new
    @bool_enum = @model.bool_var_array(3)
  end
  
  it 'should convert to a bool var array' do
    @model.allow_space_access do
      @bool_enum.bind_array.should be_kind_of(Gecode::Raw::BoolVarArray)
    end
  end
  
  it 'should define #to_bool_enum' do
    @bool_enum.to_bool_enum.should be_kind_of(
      Gecode::BoolEnum::BoolEnumOperand)
  end
end

describe Gecode::SetEnumMethods do
  before do
    @model = Gecode::Model.new
    @set_enum = @model.set_var_array(3, [0], 0..1)
  end
  
  it 'should convert to a set var array' do
    @model.allow_space_access do
      @set_enum.bind_array.should be_kind_of(Gecode::Raw::SetVarArray)
    end
  end
  
  it 'should compute the smallest upper bound union range' do
    @set_enum.upper_bound_range.should == (0..1)
    (@set_enum << @model.set_var([], -4..4)).upper_bound_range.should == (-4..4)
  end
  
  it 'should define #to_set_enum' do
    @set_enum.to_set_enum.should be_kind_of(
      Gecode::SetEnum::SetEnumOperand)
  end
end

describe Gecode::FixnumEnumMethods do
  before do
    @model = Gecode::Model.new
    @enum = @model.instance_eval{ wrap_enum([7, 14, 17, 4711]) }
  end
  
  it 'should compute the smallest domain range' do
    @enum.domain_range.should == (7..4711)
  end
  
  it 'should define #to_fixnum_enum' do
    @enum.to_fixnum_enum.should be_kind_of(
      Gecode::FixnumEnum::FixnumEnumOperand)
  end
end
