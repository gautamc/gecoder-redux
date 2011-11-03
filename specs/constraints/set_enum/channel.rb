require File.dirname(__FILE__) + '/../constraint_helper'

class ChannelSampleProblem
  include Gecode::Mixin

  attr :elements
  attr :positions
  attr :sets
  
  def initialize
    @elements = int_var_array(4, 0..3)
    @elements.must_be.distinct
    @positions = int_var_array(4, 0..3)
    @positions.must_be.distinct
    @sets = set_var_array(4, [], 0..3)
    branch_on @positions
  end
end

describe Gecode::SetEnum::Channel::IntEnumChannelConstraint, ' (channel with set as right hand side)' do
  before do
    @model = ChannelSampleProblem.new
    @positions = @model.positions
    @sets = @model.sets
    
    @types = [:int_enum, :set_enum]
    @invoke = lambda do |receiver, set_enum, hash| 
      receiver.channel(set_enum, hash)
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      Gecode::Raw.should_receive(:channel).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var1, var2)
    end
  end

  it 'should constrain variables to be channelled' do
    @positions.must.channel @sets
    @model.solve!
    sets = @model.sets
    positions = @model.positions.values
    positions.each_with_index do |position, i|
      sets[position].value.should include(i)
    end
  end
  
  it_should_behave_like 'non-reifiable set constraint'
  it_should_behave_like 'non-negatable constraint'
end

describe Gecode::SetEnum::Channel::IntEnumChannelConstraint, ' (channel with set as left hand side)' do
  before do
    @model = ChannelSampleProblem.new
    @positions = @model.positions
    @sets = @model.sets
    
    @types = [:set_enum, :int_enum]
    @invoke = lambda do |receiver, int_enum, hash| 
      receiver.channel(int_enum, hash)
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      Gecode::Raw.should_receive(:channel).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var2, var1)
    end
  end

  it 'should constrain variables to be channelled' do
    @sets.must.channel @positions
    @model.solve!
    sets = @model.sets
    positions = @model.positions.values
    positions.each_with_index do |position, i|
      sets[position].value.should include(i)
    end
  end

  it_should_behave_like 'non-reifiable set constraint'
  it_should_behave_like 'non-negatable constraint'
end
