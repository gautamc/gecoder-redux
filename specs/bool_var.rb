require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/constraints/property_helper'

describe 'non-empty bool variable', :shared => true do
  it 'should give a NoMethodError when calling a method that doesn\'t exist' do
    lambda{ @var.this_method_does_not_exists }.should raise_error(NoMethodError)
  end
end

describe Gecode::BoolVar, '(not assigned)' do
  before do
    @model = Gecode::Model.new
    @operand = @var = @model.bool_var
  end
  
  it_should_behave_like 'non-empty bool variable'
  
  it 'should not be assigned' do
    @var.should_not be_assigned
  end
  
  it "should say that it's not assigned when inspecting" do
    @var.inspect.should include('unassigned')
  end
  
  it 'should raise error when trying to access assigned value' do
    lambda{ @var.value }.should raise_error(RuntimeError)
  end

  it_should_behave_like 'bool var operand'
end

describe Gecode::BoolVar, '(assigned true)' do
  before do
    @model = Gecode::Model.new
    @operand = @var = @model.bool_var
    @var.must_be.true
    @model.solve!
  end
  
  it_should_behave_like 'non-empty bool variable'
  
  it 'should be assigned' do
    @var.should be_assigned
  end
  
  it 'should have valye true' do
    @var.value.should be_true
  end
  
  it "should say that it's true when inspecting" do
    @var.inspect.should include('true')
  end
  
  it_should_behave_like 'bool var operand'
end

describe Gecode::BoolVar, '(assigned false)' do
  before do
    @model = Gecode::Model.new
    @operand = @var = @model.bool_var
    @var.must_be.false
    @model.solve!
  end
  
  it_should_behave_like 'non-empty bool variable'
  
  it 'should be assigned' do
    @var.should be_assigned
  end
  
  it 'should have value false ' do
    @var.value.should_not be_true
  end
  
  it "should say that it's false when inspecting" do
    @var.inspect.should include('false')
  end

  it_should_behave_like 'bool var operand'
end
