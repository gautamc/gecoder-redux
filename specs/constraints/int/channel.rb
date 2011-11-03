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

describe Gecode::Int::Channel, ' (one int and one bool variable)' do
  before do
    @model = BoolChannelSampleProblem.new
    @bool = @model.bool_var
    @int = @model.int_var

    @types = [:int, :bool]
    @invoke = lambda do |receiver, bool, hash| 
      receiver.equal(bool, hash)
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      Gecode::Raw.should_receive(:channel).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var1, var2, *opts)
    end
  end

  it 'should not shadow linear boolean constraints' do
    lambda do
      (@bool + @bool).must == @bool
      @model.solve!
    end.should_not raise_error 
  end

  it 'should constrain the int variable to be 1 when the boolean variable is true' do
    @bool.must_be.true
    @int.must == @bool
    @model.solve!
    @int.value.should == 1
  end
  
  it 'should constrain the int variable to be 0 when the boolean variable is false' do
    @bool.must_be.false
    @int.must == @bool
    @model.solve!
    @int.value.should == 0
  end

  it_should_behave_like 'non-reifiable constraint'
  it_should_behave_like 'non-negatable constraint'
end

describe Gecode::Int::Channel, ' (one bool and one int variable)' do
  before do
    @model = BoolChannelSampleProblem.new
    @bool = @model.bool_var
    @int = @model.int_var

    @types = [:bool, :int]
    @invoke = lambda do |receiver, int, hash| 
      receiver.equal(int, hash)
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      Gecode::Raw.should_receive(:channel).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var2, var1, *opts)
    end
  end

  it 'should not shadow linear boolean constraints' do
    lambda do
      @bool.must == @bool + @bool
      @model.solve!
    end.should_not raise_error 
  end

  it 'should constrain the int variable to be 1 when the boolean variable is true' do
    @bool.must_be.true
    @bool.must == @int
    @model.solve!
    @int.value.should == 1
  end
  
  it 'should constrain the int variable to be 0 when the boolean variable is false' do
    @bool.must_be.false
    @bool.must == @int
    @model.solve!
    @int.value.should == 0
  end

  it_should_behave_like 'non-reifiable constraint'
  it_should_behave_like 'non-negatable constraint'
end
