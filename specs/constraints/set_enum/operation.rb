require File.dirname(__FILE__) + '/../property_helper'

# Assumes that @operation, @set and @set_enum are defined.
describe 'set enum operation property', :shared => true do
  before do
    @property_types = [:set_enum]
    @select_property = lambda do |set_enum|
      set_enum.method(@operation).call
    end
    @selected_property = @set_enum.method(@operation).call

    @constraint_class = Gecode::BlockConstraint
  end

  it "should translate #{@operation} into an operand constraint" do
    operation_type = Gecode::Util::SET_OPERATION_TYPES[@operation]
    @model.allow_space_access do
      Gecode::Raw.should_receive(:rel).with(
        an_instance_of(Gecode::Raw::Space), operation_type, 
        @set_enum.bind_array, @set.bind)
    end
    @set_enum.method(@operation).call.must == @set
    @model.solve!
  end
  
  it_should_behave_like(
    'property that produces set operand by short circuiting equality')
end

describe Gecode::SetEnum::Operation, ' (union)' do
  before do
    @model = Gecode::Model.new
    @set_enum = @sets = @model.set_var_array(10, [], 0..20)
    @set = @model.set_var([], 0..20)
    @model.branch_on @sets
    
    @operation = :union
  end

  it 'should constrain the union of the sets' do
    @sets.union.must_be.subset_of [1,4,17]
    @sets.union.must_be.superset_of 1
    @model.solve!.should_not be_nil
    union = @sets.values.inject([]){ |union, set| union += set.to_a }.uniq
    union.should include(1)
    (union - [1,4,17]).should be_empty
  end
  
  it_should_behave_like 'set enum operation property'
end

describe Gecode::SetEnum::Operation, ' (intersection)' do
  before do
    @model = Gecode::Model.new
    @set_enum = @sets = @model.set_var_array(10, [], 0..20)
    @set = @model.set_var([], 0..20)
    @model.branch_on @sets
    
    @operation = :intersection
  end

  it 'should constrain the intersection of the sets' do
    @sets.intersection.must_be.subset_of [1,4,17]
    @sets.intersection.must_be.superset_of [1]
    @model.solve!.should_not be_nil
    intersection = @sets.values.inject(nil) do |intersection, set|
      next set.to_a if intersection.nil?
      intersection &= set.to_a
    end.uniq
    intersection.should include(1)
    (intersection - [1,4,17]).should be_empty
  end
  
  it_should_behave_like 'set enum operation property'
end

describe Gecode::SetEnum::Operation, ' (disjoint union)' do
  before do
    @model = Gecode::Model.new
    @set_enum = @sets = @model.set_var_array(10, [], 0..20)
    @set = @model.set_var([], 0..20)
    @model.branch_on @sets
    
    @operation = :disjoint_union
  end

  it 'should constrain the disjoint union of the sets' do
    @sets.disjoint_union.must_be.subset_of [1,4,17]
    @sets.disjoint_union.must_be.superset_of [1]
    @model.solve!.should_not be_nil
    disjoint_union = @sets.values.inject([]) do |union, set|
      unless union.any?{ |x| set.to_a.include? x }
        union += set.to_a
      end
    end.uniq
    disjoint_union.should include(1)
    (disjoint_union - [1,4,17]).should be_empty
  end

  it 'should constrain the disjoint union of the sets (2)' do
    @sets.disjoint_union.must_be.subset_of [1,4,17]
    @sets.disjoint_union.must_be.superset_of [1]
    @sets[0].must_be.superset_of [1]
    @sets[1].must_be.superset_of [1]
    lambda do
      @model.solve!
    end.should raise_error(Gecode::NoSolutionError)
  end
  
  it_should_behave_like 'set enum operation property'
end
