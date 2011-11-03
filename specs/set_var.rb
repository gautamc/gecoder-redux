require File.dirname(__FILE__) + '/constraints/property_helper'

describe Gecode::SetVar, '(not assigned)' do
  before do
    @model = Gecode::Model.new
    @operand = @var = @model.set_var(1..3, 0..4)
  end
  
  it 'should not be assigned' do
    @var.should_not be_assigned
  end
  
  it 'should give glb and lub ranges when inspecting' do
    @var.inspect.should include('lub-range')
    @var.inspect.should include('glb-range')
  end

  it 'should allow inspection even when the bounds are too large to display' do
    var = @model.set_var
    var.inspect.should include('too large')
  end
  
  it 'should report the correct bounds' do
    @var.lower_bound.sort.to_a.should == (1..3).to_a
    @var.upper_bound.sort.to_a.should == (0..4).to_a
  end
  
  it 'should report correct bounds on upper bound' do
    @var.upper_bound.min.should == 0
    @var.upper_bound.max.should == 4
  end
  
  it 'should report correct bounds on lower bound' do
    @var.lower_bound.min.should == 1
    @var.lower_bound.max.should == 3
  end
  
  it 'should raise error when trying to access assigned value' do
    lambda{ @var.value }.should raise_error(RuntimeError)
  end
  
  it 'should not raise error when enumerating over bound multiple times' do
    # For C0 coverage.
    lower_bound = @var.lower_bound
    lambda do
      lower_bound.each{}
      lower_bound.each{}
    end.should_not raise_error
  end

  it_should_behave_like 'set var operand'
end

describe Gecode::SetVar, '(assigned)' do
  before do
    @model = Gecode::Model.new
    @operand = @var = @model.set_var(1, 1)
    @model.solve!
  end
  
  it 'should be assigned' do
    @var.should be_assigned
  end
  
  it "should give it's value when inspecting" do
    @var.inspect.should include('[1]')
    @var.inspect.should_not include('lub-range')
  end
  
  it 'should report the correct bounds' do
    @var.upper_bound.to_a.should == [1]
    @var.lower_bound.to_a.should == [1]
    @var.value.to_a.should == [1]
  end

  it 'should allow inspection even when the bounds are too large to display' do
    var = @model.set_var(0..10**4, 0..10**4)
    var.inspect.should include('too large')
  end

  it_should_behave_like 'set var operand'
end
