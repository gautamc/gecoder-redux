require File.dirname(__FILE__) + '/../constraint_helper'

class BoolChannelSampleProblem
  include Gecode::Mixin

  attr :bool_enum
  attr :bool
  attr :int
  
  def initialize
    @bool_enum = bool_var_array(4)
    @int = int_var(0..3)
    @bool = bool_var
    
    branch_on @int
  end
end

describe Gecode::BoolEnum::Channel, ' (bool enum as lhs with int variable)' do
  before do
    @model = BoolChannelSampleProblem.new
    @bools = @model.bool_enum
    @int = @model.int

    @types = [:bool_enum, :int]
    @invoke = lambda do |receiver, int, hash| 
      receiver.channel(int, hash)
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      Gecode::Raw.should_receive(:channel).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var1, var2, 0, *opts)
    end
  end

  it 'should channel the bool enum with the integer variable' do
    @int.must > 2
    @bools.must.channel @int
    @model.solve!.should_not be_nil
    int_val = @int.value
    @bools.values.each_with_index do |bool, index|
      bool.should == (index == int_val)
    end
  end
  
  it 'should take the offset into account when channeling' do
    @int.must > 2
    offset = 1
    @bools.must.channel(@int, :offset => offset)
    @model.solve!.should_not be_nil
    int_val = @int.value
    @bools.values.each_with_index do |bool, index|
      bool.should == (index + offset == int_val)
    end
  end

  it_should_behave_like 'non-reifiable constraint'
  it_should_behave_like 'non-negatable constraint'
end


describe Gecode::BoolEnum::Channel, ' (int variable as lhs with bool enum)' do
  before do
    @model = BoolChannelSampleProblem.new
    @bools = @model.bool_enum
    @int = @model.int

    @types = [:int, :bool_enum]
    @invoke = lambda do |receiver, bool_enum, hash| 
      receiver.channel(bool_enum, hash)
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      Gecode::Raw.should_receive(:channel).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var2, var1, 0, *opts)
    end
  end

  it 'should channel the bool enum with the integer variable' do
    @int.must > 2
    @int.must.channel @bools
    @model.solve!.should_not be_nil
    int_val = @int.value
    @bools.values.each_with_index do |bool, index|
      bool.should == (index == int_val)
    end
  end
  
  it 'should take the offset into account when channeling' do
    @int.must > 2
    offset = 1
    @int.must.channel(@bools, :offset => offset)
    @model.solve!.should_not be_nil
    int_val = @int.value
    @bools.values.each_with_index do |bool, index|
      bool.should == (index + offset == int_val)
    end
  end
  
  it_should_behave_like 'non-reifiable constraint'
  it_should_behave_like 'non-negatable constraint'
end
