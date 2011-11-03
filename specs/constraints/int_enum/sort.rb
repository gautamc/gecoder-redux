require File.dirname(__FILE__) + '/../constraint_helper'

class SortSampleProblem
  include Gecode::Mixin

  attr :vars
  attr :sorted
  attr :indices
  
  def initialize
    @vars = int_var_array(4, 10..19)
    @sorted = int_var_array(4, 10..19)
    @indices = int_var_array(4, 0..9)
    
    # To make it more interesting
    @vars.must_be.distinct
    
    branch_on @vars
  end
end

describe Gecode::IntEnum::Sort, ' (without :as and :order)' do
  before do
    @model = SortSampleProblem.new
    @vars = @model.vars
    @sorted = @model.sorted
    
    @types = [:int_enum]
    @invoke = lambda do |receiver, hash| 
      receiver.sorted(hash)
      @model.solve!
    end
    @expect = lambda do |var, opts, reif_var|
      if reif_var.nil?
        Gecode::Raw.should_receive(:rel).exactly(var.size - 1).times.with(
          an_instance_of(Gecode::Raw::Space), 
          an_instance_of(Gecode::Raw::IntVar), Gecode::Raw::IRT_LQ,
          an_instance_of(Gecode::Raw::IntVar), *opts)
      else
        Gecode::Raw.should_receive(:rel).once.with(
          an_instance_of(Gecode::Raw::Space), anything, 
          an_instance_of(Gecode::Raw::BoolVarArray), 
          anything, anything, anything)
        Gecode::Raw.should_receive(:rel).exactly(var.size - 1).times.with(
          an_instance_of(Gecode::Raw::Space), 
          an_instance_of(Gecode::Raw::IntVar), Gecode::Raw::IRT_LQ,
          an_instance_of(Gecode::Raw::IntVar),
          an_instance_of(Gecode::Raw::BoolVar), *opts)
      end
    end
  end
  
  it 'should constraint variables to be sorted' do
    @vars.must_be.sorted
    values = @model.solve!.vars.values
    values.should == values.sort
  end
  
  it 'should allow negation' do
    @vars.must_not_be.sorted
    @model.solve!
    values = @vars.values
    values.should_not == values.sort
  end
  
  it_should_behave_like 'reifiable constraint'
end

describe Gecode::IntEnum::Sort, ' (with :as)' do
  before do
    @model = SortSampleProblem.new
    @vars = @model.vars
    @sorted = @model.sorted
    
    # Make it a bit more interesting.
    @vars[0].must > @vars[3] + 1
    
    @types = [:int_enum, :int_enum]
    @invoke = lambda do |receiver, int_enum, hash| 
      receiver.sorted hash.update(:as => int_enum)
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      Gecode::Raw.should_receive(:sorted).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var1, var2, *opts)
    end
  end
  
  it 'should constraint variables to be sorted' do
    @vars.must_be.sorted(:as => @sorted)
    @model.solve!
    values = @sorted.values
    values.should == values.sort
  end
   
  it_should_behave_like 'non-reifiable constraint'
  it_should_behave_like 'non-negatable constraint'
end

describe Gecode::IntEnum::Sort, ' (with :order)' do
  before do
    @model = SortSampleProblem.new
    @vars = @model.vars
    @sorted = @model.sorted
    @indices = @model.indices
    
    # Make it a bit more interesting.
    @vars[0].must > @vars[3] + 1
    
    @types = [:int_enum, :int_enum]
    @invoke = lambda do |receiver, int_enum, hash| 
      receiver.sorted hash.update(:order => int_enum)
      @model.solve!
    end
    @expect = lambda do |var1, var2, opts, reif_var|
      Gecode::Raw.should_receive(:sorted).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var1, an_instance_of(Gecode::Raw::IntVarArray), var2,
        *opts)
    end
  end
  
  it 'should constraint variables to be sorted with the specified indices' do
    @vars.must_be.sorted(:order => @indices)
    @model.solve!
    sorted_values = @vars.values.sort
    expected_indices = @vars.map{ |v| sorted_values.index(v.value) }
    @indices.values.should == expected_indices
  end
  
  it_should_behave_like 'non-reifiable constraint'
  it_should_behave_like 'non-negatable constraint'
end

describe Gecode::IntEnum::Sort, ' (with :order and :as)' do
  before do
    @model = SortSampleProblem.new
    @vars = @model.vars
    @sorted = @model.sorted
    @indices = @model.indices
    
    # Make it a bit more interesting.
    @vars[0].must > @vars[3] + 1
    
    @types = [:int_enum, :int_enum, :int_enum]
    @invoke = lambda do |receiver, int_enum1, int_enum2, hash| 
      receiver.sorted hash.update(:as => int_enum1, :order => int_enum2)
      @model.solve!
    end
    @expect = lambda do |var1, var2, var3, opts, reif_var|
      Gecode::Raw.should_receive(:sorted).once.with(
        an_instance_of(Gecode::Raw::Space), 
        var1, var2, var3, *opts)
    end
  end
  
  it 'should constraint variables to be sorted with the specified indices' do
    @vars.must_be.sorted(:as => @sorted, :order => @indices)
    @model.solve!
    sorted_values = @sorted.values
    sorted_values.should == sorted_values.sort
    expected_indices = @vars.map{ |v| sorted_values.index(v.value) }
    @indices.values.should == expected_indices
  end
  
  it_should_behave_like 'non-reifiable constraint'
  it_should_behave_like 'non-negatable constraint'
end
