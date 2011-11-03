require File.dirname(__FILE__) + '/spec_helper'

class BranchSampleProblem
  include Gecode::Mixin

  attr :vars
  attr :bools
  attr :sets
  
  def initialize
    @vars = int_var_array(2, 0..3)
    @sets = set_var_array(2, [], 0..4)
    @bools = bool_var_array(2)
  end
end

describe Gecode::Mixin, ' (integer branch)' do
  before do
    @model = BranchSampleProblem.new
    @vars = @model.vars
    @bools = @model.bools
  end

  it 'should default to :none and :min' do
    Gecode::Raw.should_receive(:branch).once.with(
      an_instance_of(Gecode::Raw::Space), 
      anything, Gecode::Raw::INT_VAR_NONE, Gecode::Raw::INT_VAL_MIN)
    @model.branch_on @vars
    @model.solve!
  end
  
  it 'should ensure that branched int variables are assigned in a solution' do
    @model.branch_on @vars
    @model.solve!.vars.each{ |var| var.should be_assigned }
  end
  
  it 'should ensure that branched bool variables are assigned in a solution' do
    @model.branch_on @bools
    @model.solve!.bools.each{ |var| var.should be_assigned }
  end

  it 'should allow branching on a single integer variable' do
    @model.branch_on @vars.first
    @model.solve!.vars.first.should be_assigned
  end

  it 'should allow branching on a single boolean variable' do
    @model.branch_on @bools.first
    @model.solve!.bools.first.should be_assigned
  end

  supported_var_selectors = {
    :none                 => Gecode::Raw::INT_VAR_NONE,
    :smallest_min         => Gecode::Raw::INT_VAR_MIN_MIN,
    :largest_min          => Gecode::Raw::INT_VAR_MIN_MAX, 
    :smallest_max         => Gecode::Raw::INT_VAR_MAX_MIN, 
    :largest_max          => Gecode::Raw::INT_VAR_MAX_MAX, 
    :smallest_size        => Gecode::Raw::INT_VAR_SIZE_MIN, 
    :largest_size         => Gecode::Raw::INT_VAR_SIZE_MAX,
    :smallest_degree      => Gecode::Raw::INT_VAR_DEGREE_MIN, 
    :largest_degree       => Gecode::Raw::INT_VAR_DEGREE_MAX, 
    :smallest_min_regret  => Gecode::Raw::INT_VAR_REGRET_MIN_MIN,
    :largest_min_regret   => Gecode::Raw::INT_VAR_REGRET_MIN_MAX,
    :smallest_max_regret  => Gecode::Raw::INT_VAR_REGRET_MAX_MIN, 
    :largest_max_regret   => Gecode::Raw::INT_VAR_REGRET_MAX_MAX
  }.each_pair do |name, gecode_const|
    it "should support #{name} as variable selection strategy" do
      Gecode::Raw.should_receive(:branch).once.with(
        an_instance_of(Gecode::Raw::Space),
        anything, gecode_const, an_instance_of(Numeric))
      @model.branch_on @vars, :variable => name
      @model.solve!
    end
  end

  supported_val_selectors = {
    :min        => Gecode::Raw::INT_VAL_MIN,
    :med        => Gecode::Raw::INT_VAL_MED,
    :max        => Gecode::Raw::INT_VAL_MAX,
    :split_min  => Gecode::Raw::INT_VAL_SPLIT_MIN,
    :split_max  => Gecode::Raw::INT_VAL_SPLIT_MAX
  }.each_pair do |name, gecode_const|
    it "should support #{name} as value selection strategy" do
      Gecode::Raw.should_receive(:branch).once.with(
        an_instance_of(Gecode::Raw::Space), 
        anything, an_instance_of(Numeric), gecode_const)
      @model.branch_on @vars, :value => name
      @model.solve!
    end
  end

  it 'should raise errors for unrecognized var selection strategies' do
    lambda do 
      @model.branch_on @vars, :variable => :foo 
    end.should raise_error(ArgumentError)
  end
  
  it 'should raise errors for unrecognized val selection strategies' do
    lambda do 
      @model.branch_on @vars, :value => :foo 
    end.should raise_error(ArgumentError)
  end

  it 'should raise errors for unrecognized options' do
    lambda do
      @model.branch_on @vars, :foo => 5 
    end.should raise_error(ArgumentError)
  end
  
  it 'should raise errors for unrecognized enumerations' do
    lambda do
      @model.branch_on [1,2,3]
    end.should raise_error(TypeError)
  end
end

describe Gecode::Mixin, ' (set branch)' do
  before do
    @model = BranchSampleProblem.new
    @sets = @model.sets
  end

  it 'should default to :none and :min' do
    Gecode::Raw.should_receive(:branch).once.with(
      an_instance_of(Gecode::Raw::Space), 
      anything, Gecode::Raw::SET_VAR_NONE, Gecode::Raw::SET_VAL_MIN)
    @model.branch_on @sets
    @model.solve!
  end
  
  it 'should ensure that branched set variables are assigned in a solution' do
    @model.branch_on @sets
    @model.solve!.sets.each{ |var| var.should be_assigned }
  end
  
  it 'should allow branching on a single set variable' do
    @model.branch_on @sets.first
    @model.solve!.sets.first.should be_assigned
  end

  supported_var_selectors = {
    :none                 => Gecode::Raw::SET_VAR_NONE,
    :smallest_cardinality => Gecode::Raw::SET_VAR_MIN_CARD,
    :largest_cardinality  => Gecode::Raw::SET_VAR_MAX_CARD, 
    :smallest_unknown     => Gecode::Raw::SET_VAR_MIN_UNKNOWN_ELEM, 
    :largest_unknown      => Gecode::Raw::SET_VAR_MAX_UNKNOWN_ELEM
  }.each_pair do |name, gecode_const|
    it "should support #{name} as variable selection strategy" do
      Gecode::Raw.should_receive(:branch).once.with(
        an_instance_of(Gecode::Raw::Space),
        anything, gecode_const, an_instance_of(Numeric))
      @model.branch_on @sets, :variable => name
      @model.solve!
    end
  end

  supported_val_selectors = {
    :min  => Gecode::Raw::SET_VAL_MIN,
    :max  => Gecode::Raw::SET_VAL_MAX
  }.each_pair do |name, gecode_const|
    it "should support #{name} as value selection strategy" do
      Gecode::Raw.should_receive(:branch).once.with(
        an_instance_of(Gecode::Raw::Space), 
        anything, an_instance_of(Numeric), gecode_const)
      @model.branch_on @sets, :value => name
      @model.solve!
    end
  end

  it 'should raise errors for unrecognized var selection strategies' do
    lambda do 
      @model.branch_on @sets, :variable => :foo 
    end.should raise_error(ArgumentError)
  end
  
  it 'should raise errors for unrecognized val selection strategies' do
    lambda do 
      @model.branch_on @sets, :value => :foo 
    end.should raise_error(ArgumentError)
  end

  it 'should raise errors for unrecognized options' do
    lambda do
      @model.branch_on @sets, :foo => 5 
    end.should raise_error(ArgumentError)
  end
end
