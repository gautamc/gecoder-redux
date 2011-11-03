require File.dirname(__FILE__) + '/../constraint_helper'

class SetChannelSampleProblem
  include Gecode::Mixin

  attr :bool_enum
  attr :set
  
  def initialize
    @bool_enum = bool_var_array(4)
    @set = set_var([], 0..3)
    
    branch_on @bool_enum
  end
end

describe Gecode::Set::Channel, ' (set variable as lhs with bool enum)' do
  before do
    @model = SetChannelSampleProblem.new
    @bools = @model.bool_enum
    @set = @model.set
    
    @types = [:set, :bool_enum]
    @invoke = lambda do |receiver, bool_enum, hash| 
      receiver.channel(bool_enum, hash)
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      Gecode::Raw.should_receive(:channel).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var1, var2)
    end
  end

  it 'should channel the bool enum with the set variable' do
    @set.must_be.superset_of [0, 2]
    @set.must.channel @bools
    @model.solve!.should_not be_nil
    set_values = @set.value
    @bools.values.each_with_index do |bool, index|
      bool.should == set_values.include?(index)
    end
  end

  it_should_behave_like 'non-reifiable set constraint'
  it_should_behave_like 'non-negatable constraint'
end

describe Gecode::Set::Channel, ' (bool enum as lhs with set variable)' do
  before do
    @model = SetChannelSampleProblem.new
    @bools = @model.bool_enum
    @set = @model.set
    
    @types = [:bool_enum, :set]
    @invoke = lambda do |receiver, set, hash| 
      receiver.channel(set, hash)
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      Gecode::Raw.should_receive(:channel).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var1, var2)
    end
  end

  it 'should channel the bool enum with the set variable' do
    @set.must_be.superset_of [0, 2]
    @bools.must.channel @set
    @model.solve!.should_not be_nil
    set_values = @set.value
    @bools.values.each_with_index do |bool, index|
      bool.should == set_values.include?(index)
    end
  end

  it_should_behave_like 'non-reifiable set constraint'
  it_should_behave_like 'non-negatable constraint'
end
