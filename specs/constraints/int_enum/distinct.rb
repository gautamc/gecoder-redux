require File.dirname(__FILE__) + '/../constraint_helper'

class DistinctSampleProblem
  include Gecode::Mixin

  def initialize
    vars_is_an int_var_array(2, 0..1)
    branch_on vars
  end
end

describe Gecode::IntEnum::Distinct do
  before do
    @model = DistinctSampleProblem.new

    @types = [:int_enum]
    @invoke = lambda do |receiver, hash| 
      receiver.distinct(hash)
      @model.solve!
    end
    @expect = lambda do |var, opts, reif_var|
      Gecode::Raw.should_receive(:distinct).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var, *opts)
    end
  end

  it 'should constrain variables to be distinct' do
    @model.vars.must_be.distinct
    @model.solve!
    @model.vars[0].value.should_not == @model.vars[1].value
  end

  it_should_behave_like 'non-reifiable constraint'
  it_should_behave_like 'non-negatable constraint'
end

describe Gecode::IntEnum::Distinct, ' (with offsets)' do
  before do
    @model = DistinctSampleProblem.new

    @types = [:int_enum]
    @invoke = lambda do |receiver, hash| 
      receiver.distinct hash.update(:offsets => [1,2])
      @model.solve!
    end
    @expect = lambda do |var, opts, reif_var|
      if reif_var.nil?
        Gecode::Raw.should_receive(:distinct).once.with(
          an_instance_of(Gecode::Raw::Space), 
          [1,2], var, *opts)
      else
        Gecode::Raw.should_receive(:distinct).once.with(
          an_instance_of(Gecode::Raw::Space), 
          [1,2], var, reif_var, *opts)
      end
    end
  end

  it 'should constrain variables to be distinct' do
    @model.vars.must_be.distinct(:offsets => [-1, 0])
    x, y = @model.solve!.vars
    (x.value - 1).should_not == y.value
  end
  
  # This tests two distinct in conjunction. It's here because of a bug found.
  it 'should play nice with normal distinct' do
    @model.vars.must_be.distinct(:offsets => [-1, 0])
    @model.vars.must_be.distinct(:offsets => [0, -1])
    @model.vars.must_be.distinct
    lambda{ @model.solve! }.should raise_error(Gecode::NoSolutionError)
  end

  it 'should raise error if the offsets are of an incorrect type' do
    lambda do
      @model.vars.must_be.distinct(:offsets => :foo)
    end.should raise_error(TypeError)
  end
  
  it_should_behave_like 'non-reifiable constraint'
  it_should_behave_like 'non-negatable constraint'
end
