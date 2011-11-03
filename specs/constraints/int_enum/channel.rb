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

describe Gecode::IntEnum::Channel, ' (two int enums)' do
  before do
    @model = ChannelSampleProblem.new
    @positions = @model.positions
    @elements = @model.elements

    @types = [:int_enum, :int_enum]
    @invoke = lambda do |receiver, int_enum, hash| 
      receiver.channel(int_enum, hash)
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      Gecode::Raw.should_receive(:channel).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var1, var2, *opts)
    end
  end

  it 'should translate into a channel constraint' do
    Gecode::Raw.should_receive(:channel).once.with(
      an_instance_of(Gecode::Raw::Space), 
      anything, anything, Gecode::Raw::ICL_DEF, Gecode::Raw::PK_DEF)
    @positions.must.channel @elements
    @model.solve!
  end

  it 'should constrain variables to be channelled' do
    @elements.must.channel @positions
    @model.solve!
    elements = @model.elements.values
    positions = @model.elements.values
    elements.each_with_index do |element, i|
      element.should equal(positions.index(i))
    end
  end
  
  it_should_behave_like 'non-reifiable constraint'
  it_should_behave_like 'non-negatable constraint'
end

