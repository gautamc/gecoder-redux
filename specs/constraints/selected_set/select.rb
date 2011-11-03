require File.dirname(__FILE__) + '/../constraint_helper'

class DisjointSelectSampleProblem
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

describe Gecode::SetEnum::Element, ' (disjoint)' do
  include GecodeR::Specs::SetHelper

  before do
    @model = DisjointSelectSampleProblem.new
    @sets = @model.sets
    @set = @model.set
    @target = @model.target
    @model.branch_on @model.wrap_enum([@target, @set])
    
    @types = [:selected_set]
    @invoke = lambda do |receiver, hash| 
      receiver.disjoint(hash)
      @model.solve!
    end
    @expect = lambda do |var, opts, reif_var|
      set_enum, set = var
      Gecode::Raw.should_receive(:elementDisjoint).once.with(
        an_instance_of(Gecode::Raw::Space), 
        set_enum, set)
    end
  end
  
  it 'should constrain the selected sets to be disjoint' do
    @sets[0].must_be.superset_of([7,8])
    @sets[1].must_be.superset_of([5,7,9])
    @sets[2].must_be.superset_of([6,8,10])
    @sets[@set].must_be.disjoint
    @set.size.must > 1
    @model.solve!.should_not be_nil
    
    @set.value.to_a.sort.should == [1,2]
  end
  
  it_should_behave_like 'non-reifiable set constraint'
  it_should_behave_like 'non-negatable constraint'
end
