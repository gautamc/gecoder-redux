require File.dirname(__FILE__) + '/../constraint_helper'

describe Gecode::Set::Connection, ' (include)' do
  before do
    @model = Gecode::Model.new
    @set = @model.set_var([], 2..5)
    @array = @model.int_var_array(4, 0..9)
    @array.must_be.distinct
    @model.branch_on @array
    #@model.branch_on @model.wrap_enum([@set])

    @types = [:set, :int_enum]
    @invoke = lambda do |receiver, int_enum, hash| 
      if hash.empty?
        receiver.include(int_enum)
      else
        receiver.include(int_enum, hash)
      end
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      Gecode::Raw.should_receive(:match).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var1, var2)
    end
  end
  
  it 'should constrain the variables to be included in the set' do
    @set.must.include @array
    @model.solve!.should_not be_nil
    @array.all?{ |x| @set.lower_bound.include? x.value }.should be_true
  end
 
  it_should_behave_like 'non-reifiable set constraint'
  it_should_behave_like 'non-negatable constraint'
end
