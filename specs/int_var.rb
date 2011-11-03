require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/constraints/property_helper'

describe 'non-empty int variable', :shared => true do
  it 'should have min equal to the lower domain bound' do
    @var.min.should equal(@domain.min)
  end
  
  it 'should have max equal to the upper domain bound' do
    @var.max.should equal(@domain.max)
  end
  
  it 'should have size equal to the domain size' do
    @var.size.should equal(@domain.size)
  end
  
  it 'should contain every element in its domain' do 
    @domain.each do |i|
      @var.should include(i)
    end
  end
  
  it 'should not contain elements outside its domain' do
    @var.should_not include(@domain.min - 1)
    @var.should_not include(@domain.max + 1)
  end
  
  it 'should have a width equal to the domain width' do
    @var.width.should equal(@domain.max - @domain.min + 1)
  end
  
  it 'should give a NoMethodError when calling a method that doesn\'t exist' do
    lambda{ @var.this_method_does_not_exists }.should raise_error(NoMethodError)
  end
  
  it 'should have a zero degree' do
    @var.degree.should be_zero
  end

  it 'should return the correct domain through #domain' do
    @var.domain.to_a.should == @domain.to_a
  end

  it_should_behave_like 'int var operand'
end

describe Gecode::IntVar, ' (with range domain of size > 1)' do
  before do
    @range = -4..3
    @domain = @range.to_a
    @model = Gecode::Model.new
    @operand = @var = @model.int_var(@range)
  end
  
  it 'should not be assigned' do
    @var.should_not be_assigned
  end
  
  it 'should have a range domain' do
    @var.should be_range
  end
  
  it 'should raise error when trying to access assigned value' do
    lambda{ @var.value }.should raise_error(RuntimeError)
  end

  it_should_behave_like 'non-empty int variable'
end

describe Gecode::IntVar, ' (defined with three-dot range)' do
  before do
    @range = -4...3
    @domain = @range.to_a
    @model = Gecode::Model.new
    @operand = @var = @model.int_var(@range)
  end
  
  it_should_behave_like 'non-empty int variable'
end

describe Gecode::IntVar, ' (with non-range domain of size > 1)' do
  before do
    @domain = [-3, -2, -1, 1]
    @model = Gecode::Model.new
    @operand = @var = @model.int_var(@domain)
  end

  it 'should not be assigned' do
    @var.should_not be_assigned
  end
  
  it 'should not be a range domain' do
    @var.should_not be_range
  end
  
  it 'should not contain the domain\'s holes' do
    @var.should_not include(0)
  end
  
  it_should_behave_like 'non-empty int variable'
end

describe Gecode::IntVar, ' (with a domain of size 1)' do
  before do
    @domain = [1]
    @model = Gecode::Model.new
    @operand = @var = @model.int_var(*@domain)
  end
  
  it 'should be assigned' do
    @var.should be_assigned
  end
  
  it 'should be a range domain' do
    @var.should be_range
  end
  
  it_should_behave_like 'non-empty int variable'
end

describe Gecode::IntVar, ' (assigned)' do
  before do
    @domain = 1
    @model = Gecode::Model.new
    @operand = @var = @model.int_var(*@domain)
  end

  it 'should be assigned' do
    @var.should be_assigned
  end
  
  it 'should give the assigned number when inspecting' do
    @var.inspect.should include(" #{@domain[0]}>")
  end

  it 'should return the correct domain through #domain' do
    @var.domain.to_a.should == [@domain]
  end

  it_should_behave_like 'int var operand'
end

describe Gecode::IntVar, ' (not assigned)' do
  before do
    @domain = 1..2
    @model = Gecode::Model.new
    @operand = @var = @model.int_var(@domain)
  end

  it 'should not be assigned' do
    @var.should_not be_assigned
  end
  
  it 'should give the domain range when inspecting' do
    @var.inspect.should include(" #{@domain.first}..#{@domain.last}>")
  end

  it 'should return the correct domain through #domain' do
    @var.domain.to_a.should == @domain.to_a
  end

  it_should_behave_like 'int var operand'
end
