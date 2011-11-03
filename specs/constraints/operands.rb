require File.dirname(__FILE__) + '/../spec_helper'

describe 'operand', :shared => true do
  it 'should not shadow method missing' do
    lambda do
      @operand.does_not_exist
    end.should raise_error(NoMethodError)
  end
end

describe 'variable operand', :shared => true do
  it 'should fall back to the underlying variable' do
    lambda do 
      @operand.assigned?
    end.should_not raise_error
  end

  it_should_behave_like 'operand'
end

describe 'enum operand', :shared => true do
  it 'should fall back to the underlying enum' do
    lambda do 
      @operand[0]
    end.should_not raise_error
  end

  it_should_behave_like 'operand'
end

describe Gecode::Operand do
  before do
    model = Gecode::Model.new
    @operand = Object.new
    class <<@operand
      include Gecode::Operand
    end
  end

  it 'should raise error if #model is not defined' do
    lambda do
      @operand.model
    end.should raise_error(NotImplementedError)
  end

  it 'should raise error if #construct_receiver is not defined' do
    lambda do
      @operand.must
    end.should raise_error(NotImplementedError)
  end
end

describe Gecode::Int::IntOperand do
  before do
    model = Gecode::Model.new
    @operand, _ = general_int_operand(model)
  end

  it_should_behave_like 'variable operand'
end

describe Gecode::Int::ShortCircuitEqualityOperand, ' (not subclassed)' do
  before do
    @model = Gecode::Model.new
    @operand = Gecode::Int::ShortCircuitEqualityOperand.new(@model)
  end

  it 'should raise error if #constrain_equal is called' do
    lambda do
      @operand.to_int_var
      @model.solve!
    end.should raise_error(NotImplementedError)
  end
end

describe Gecode::Int::ShortCircuitRelationsOperand, ' (not subclassed)' do
  before do
    @model = Gecode::Model.new
    @operand = Gecode::Int::ShortCircuitRelationsOperand.new(@model)
  end

  it 'should raise error if #constrain_equal is called' do
    lambda do
      @operand.to_int_var
      @model.solve!
    end.should raise_error(NotImplementedError)
  end
end

describe Gecode::IntEnum::IntEnumOperand do
  before do
    model = Gecode::Model.new
    @operand, _ = general_int_enum_operand(model)
  end

  it_should_behave_like 'enum operand'
end

describe Gecode::Bool::BoolOperand do
  before do
    model = Gecode::Model.new
    @operand, _ = general_bool_operand(model)
  end

  it_should_behave_like 'variable operand'
end

describe Gecode::Bool::ShortCircuitEqualityOperand, ' (not subclassed)' do
  before do
    @model = Gecode::Model.new
    @operand = Gecode::Bool::ShortCircuitEqualityOperand.new(@model)
  end

  it 'should raise error if #constrain_equal is called' do
    lambda do
      @operand.to_bool_var
      @model.solve!
    end.should raise_error(NotImplementedError)
  end
end

describe Gecode::BoolEnum::BoolEnumOperand do
  before do
    model = Gecode::Model.new
    @operand, _ = general_bool_enum_operand(model)
  end

  it_should_behave_like 'enum operand'
end

describe Gecode::Set::SetOperand do
  before do
    model = Gecode::Model.new
    @operand, _ = general_set_operand(model)
  end

  it_should_behave_like 'variable operand'
end

describe Gecode::Set::ShortCircuitEqualityOperand, ' (not subclassed)' do
  before do
    @model = Gecode::Model.new
    @operand = Gecode::Set::ShortCircuitEqualityOperand.new(@model)
  end

  it 'should raise error if #constrain_equal is called' do
    lambda do
      @operand.to_set_var
      @model.solve!
    end.should raise_error(NotImplementedError)
  end
end

describe Gecode::Set::ShortCircuitRelationsOperand, ' (not subclassed)' do
  before do
    @model = Gecode::Model.new
    @operand = Gecode::Set::ShortCircuitRelationsOperand.new(@model)
  end

  it 'should raise error if #constrain_equal is called' do
    lambda do
      @operand.to_set_var
      @model.solve!
    end.should raise_error(NotImplementedError)
  end
end

describe Gecode::SelectedSet::SelectedSetOperand do
  before do
    model = Gecode::Model.new
    @operand, ops = general_selected_set_operand(model)
    @enum, @set = ops
  end

  it 'should raise error if set enum operand is not given' do
    lambda do
      Gecode::SelectedSet::SelectedSetOperand.new(:foo, @set)
    end.should raise_error(TypeError)
  end

  it 'should raise error if set operand is not given' do
    lambda do
      Gecode::SelectedSet::SelectedSetOperand.new(@enum, :foo)
    end.should raise_error(TypeError)
  end

  it_should_behave_like 'operand'
end

describe Gecode::SetElements::SetElementsOperand do
  before do
    model = Gecode::Model.new
    @operand, @set = general_set_elements_operand(model)
  end

  it 'should raise error if set operand is not given' do
    lambda do
      Gecode::SetElements::SetElementsOperand.new(:foo)
    end.should raise_error(TypeError)
  end

  it_should_behave_like 'operand'
end

describe Gecode::SetEnum::SetEnumOperand do
  before do
    model = Gecode::Model.new
    @operand, _ = general_set_enum_operand(model)
  end

  it_should_behave_like 'enum operand'
end

describe Gecode::FixnumEnum::FixnumEnumOperand do
  before do
    model = Gecode::Model.new
    @operand, _ = general_fixnum_enum_operand(model)
  end

  it 'should raise error if constraint receiver is called' do
    lambda do
      @operand.must
    end.should raise_error(NotImplementedError)
  end

  it_should_behave_like 'enum operand'
end

# High level sanity check.
describe 'operand combination' do
  it 'should allow placing constraints on complicated combinations of operands' do
    model = Gecode::Model.new
    sets = model.set_var_array(2, [], 0..9)
    set1, set2 = sets
    (set1.size + set2.size).must == 5
    set1.size.must > 1
    set2.size.must > 1
    model.branch_on sets

    model.solve!

    (set1.value.size + set2.value.size).should == 5
    set1.value.size.should > 1
    set2.value.size.should > 1
  end

  it 'should allow placing constraints on complicated combinations of operands (2)' do
    model = Gecode::Model.new
    sets = model.set_var_array(3, [], 0..9)
    set1, set2, set3 = sets
    (set1.size + set2.size).must == (set3.size - set1.max)
    set3.size.must > 3
    set2.size.must < 3
    set1.size.must > 0
    model.branch_on sets

    model.solve!

    (set1.value.size + set2.value.size).should == (set3.value.size - set1.value.max)
    set3.value.size.should > 3
    set2.value.size.should < 3
    set1.value.size.should > 0
  end
end
