require File.dirname(__FILE__) + '/../property_helper'

class SelectionSampleProblem
  include Gecode::Mixin

  attr :sets
  attr :set
  attr :target
  attr :index
  
  def initialize
    @sets = set_var_array(3, [], 0..20)
    @set = set_var([], 0...3)
    @target = set_var([], 0..20)
    @index = int_var(0...3)
    branch_on wrap_enum([@index])
    branch_on @sets
  end
end

describe Gecode::SelectedSet::Element, ' (union)' do
  include GecodeR::Specs::SetHelper

  before do
    @model = SelectionSampleProblem.new
    @sets = @model.sets
    @set = @model.set
    @model.branch_on @set

    @property_types = [:selected_set]
    @select_property = lambda do |selected_set|
      selected_set.union
    end
    @selected_property = @sets[@set].union
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the selected union of an enum of sets' do
    @sets[@set].union.must_be.subset_of([5,7,9])
    @sets[@set].union.must_be.superset_of([5])
    @model.solve!
    union = @set.value.inject([]) do |union, i|
      union += @sets[i].value.to_a
    end.uniq
    union.should include(5)
    (union - [5,7,9]).should be_empty
  end

  it 'should translate into a elements union constraint' do
    Gecode::Raw.should_receive(:elementsUnion)
    @sets[@set].union.must_be.subset_of([5,7,9])
    @model.solve!
  end
  
  it_should_behave_like(
    'property that produces set operand by short circuiting equality')
end

describe Gecode::SetEnum::Element, ' (intersection)' do
  include GecodeR::Specs::SetHelper

  before do
    @model = SelectionSampleProblem.new
    @sets = @model.sets
    @set = @model.set
    @model.branch_on @set

    @property_types = [:selected_set]
    @select_property = lambda do |selected_set|
      selected_set.intersection
    end
    @selected_property = @sets[@set].intersection
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the selected intersection of an enum of sets' do
    @sets[@set].intersection.must_be.subset_of([5,7,9])
    @sets[@set].intersection.must_be.superset_of([5])
    @model.solve!
    intersection = @set.value.inject(nil) do |intersection, i|
      elements = @sets[i].value.to_a
      next elements if intersection.nil?
      intersection &= elements
    end.uniq
    intersection.should include(5)
    (intersection - [5,7,9]).should be_empty
  end

  it 'should translate into a elements intersection constraint' do
    Gecode::Raw.should_receive(:elementsInter)
    @sets[@set].intersection.must_be.subset_of([5,7,9])
    @model.solve!
  end
  
  it_should_behave_like(
    'property that produces set operand by short circuiting equality')
end

describe Gecode::SelectedSet::Element, ' (intersection with universe)' do
  include GecodeR::Specs::SetHelper

  before do
    @model = SelectionSampleProblem.new
    @sets = @model.sets
    @set = @model.set
    @model.branch_on @set
    @universe = [1,2]
    
    @property_types = [:selected_set]
    @select_property = lambda do |selected_set|
      selected_set.intersection(:with => @universe)
    end
    @selected_property = @sets[@set].intersection(:with => @universe)
    @constraint_class = Gecode::BlockConstraint
  end
  
  it 'should constrain the selected intersection of an enum of sets in a universe' do
    @sets[@set].intersection(:with => @universe).must_be.subset_of([2])
    @model.solve!
    intersection = @set.value.inject(@universe) do |intersection, i|
      intersection &= @sets[i].value.to_a
    end.uniq
    intersection.should include(2)
    (intersection - [1,2]).should be_empty
  end
  
  it 'should allow the universe to be specified as a range' do
    @sets[@set].intersection(:with => 1..2).must_be.subset_of([2])
    @model.solve!
    intersection = @set.value.inject(@universe) do |intersection, i|
      intersection &= @sets[i].value.to_a
    end.uniq
    intersection.should include(2)
    (intersection - [1,2]).should be_empty
  end

  it 'should translate into a elements intersection constraint' do
    Gecode::Raw.should_receive(:elementsInter)
    @sets[@set].intersection(:with => 1..2).must_be.subset_of([5,7,9])
    @model.solve!
  end
  
  it 'should raise error if unknown options are specified' do
    lambda do
      @sets[@set].intersection(:does_not_exist => nil).must_be.subset_of([2])
    end.should raise_error(ArgumentError)
  end
  
  it 'should raise error if the universe is of the wrong type' do
    lambda do
      @sets[@set].intersection(:with => 'foo').must_be.subset_of([2])
    end.should raise_error(TypeError)
  end
  
  it_should_behave_like(
    'property that produces set operand by short circuiting equality')
end


