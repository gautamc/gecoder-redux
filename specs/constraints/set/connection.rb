require File.dirname(__FILE__) + '/../property_helper'

describe Gecode::Set::Connection, ' (min)' do
  before do
    @model = Gecode::Model.new
    @set = @model.set_var([], 0..9)
    @var = @model.int_var(0..10)
    @model.branch_on @model.wrap_enum([@set])

    @property_types = [:set]
    @select_property = lambda do |set|
      set.min
    end
    @selected_property = @set.min
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the min of a set' do
    @set.min.must == 3
    @model.solve!
    @set.lower_bound.min.should == 3
  end

  it 'should translate into a min constraint' do
    Gecode::Raw.should_receive(:min)
    @set.min.must == 5
    @model.solve!
  end
  
  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end

describe Gecode::Set::Connection, ' (max)' do
  before do
    @model = Gecode::Model.new
    @set = @model.set_var([], 0..9)
    @var = @model.int_var(0..10)
    @model.branch_on @model.wrap_enum([@set])

    @property_types = [:set]
    @select_property = lambda do |set|
      set.max
    end
    @selected_property = @set.max
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the max of a set' do
    @set.max.must == 3
    @model.solve!
    @set.lower_bound.max.should == 3
  end
  
  it 'should translate into a max constraint' do
    Gecode::Raw.should_receive(:max)
    @set.max.must == 5
    @model.solve!
  end

  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end

describe Gecode::Set::Connection, ' (sum)' do
  before do
    @model = Gecode::Model.new
    @set = @model.set_var([], 0..9)
    @target = @var = @model.int_var(0..20)
    @model.branch_on @model.wrap_enum([@set])

    @property_types = [:set]
    @select_property = lambda do |set|
      set.sum
    end
    @selected_property = @set.sum
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the sum of a set' do
    @set.sum.must == 7
    @model.solve!.should_not be_nil
    @set.value.inject(0){ |x, y| x + y }.should == 7
  end

  it 'should translate into a weights constraint' do
    Gecode::Raw.should_receive(:weights)
    @set.sum.must == 5
    @model.solve!
  end
  
  it 'should raise error if unsupported options is given' do
    lambda do
      @set.sum(:does_not_exist => :foo).must == @var 
    end.should raise_error(ArgumentError)
  end
  
  it 'should raise error if multiple options are given' do
    lambda do
      @set.sum(:weights => {}, :substitutions => {}).must == @var 
    end.should raise_error(ArgumentError)
  end
  
  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end

describe Gecode::Set::Connection, ' (sum with weights)' do
  before do
    @model = Gecode::Model.new
    @set = @model.set_var([], 0..9)
    @target = @var = @model.int_var(-20..20)
    @model.branch_on @model.wrap_enum([@set])
    @weights = Hash[*(0..9).zip((-9..-0).to_a.reverse).flatten]
  
    @property_types = [:set]
    @select_property = lambda do |set|
      set.sum(:weights => @weights)
    end
    @selected_property = @set.sum(:weights => @weights)
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the sum of a set' do
    @set.sum(:weights => @weights).must_be.in(-10..-1)
    @model.solve!.should_not be_nil
    weighted_sum = @set.value.inject(0){ |sum, x| sum - x**2 }
    weighted_sum.should >= -10
    weighted_sum.should <= -1
  end
  
  it 'should remove any elements not in the weight hash' do
    @set.must_be.superset_of 0
    @set.sum(:weights => {}).must_be == 0
    lambda do
      @model.solve!
    end.should raise_error(Gecode::NoSolutionError)
  end
  
  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end

describe Gecode::Set::Connection, ' (sum with substitutions)' do
  before do
    @model = Gecode::Model.new
    @set = @model.set_var([], 0..9)
    @target = @var = @model.int_var(-20..20)
    @model.branch_on @model.wrap_enum([@set])
    @subs = Hash[*(0..9).zip((-9..-0).to_a.reverse).flatten]

    @property_types = [:set]
    @select_property = lambda do |set|
      set.sum(:substitutions => @subs)
    end
    @selected_property = @set.sum(:substitutions => @subs)
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the sum of a set' do
    @set.sum(:substitutions => @subs).must_be.in(-10..-1)
    @model.solve!.should_not be_nil
    substituted_sum = @set.value.inject{ |sum, x| sum + @subs[x] }
    substituted_sum.should >= -10
    substituted_sum.should <= -1
  end

  it 'should not be allowed together with :weights option' do
    lambda do
      @set.sum(:substitutions => @subs, :weights => [1]*20).must_be.in(-10..-1)
    end.should raise_error(ArgumentError)
  end
  
  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end
