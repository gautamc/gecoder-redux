require File.dirname(__FILE__) + '/../constraint_helper'

describe Gecode::IntEnum::Equality do
  before do
    @model = Gecode::Model.new
    @vars = @model.int_var_array(4, -2..2)

    @types = [:int_enum]
    @invoke = lambda do |receiver, hash| 
      receiver.equal(hash)
      @model.solve!
    end
    @expect = lambda do |var, opts, reif_var|
      Gecode::Raw.should_receive(:rel).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var, Gecode::Raw::IRT_EQ, *opts)
    end
  end
  
  it 'should constrain elements to be equal' do
    @vars[1].must == 1
    @vars.must_be.equal
    @model.solve!
    @vars.values.each{ |x| x.should == 1 }
  end
  
  it_should_behave_like 'non-reifiable constraint'
  it_should_behave_like 'non-negatable constraint'
end
