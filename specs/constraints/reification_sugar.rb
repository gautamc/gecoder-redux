require File.dirname(__FILE__) + '/../spec_helper'

class ReifSugarSampleProblem
  include Gecode::Mixin

  attr :x
  attr :y
  attr :z
  
  def initialize
    @x = int_var(0..1)
    @y = int_var(1..2)
    @z = int_var(3..4)
    branch_on wrap_enum([@x, @y, @z])
  end
end

describe Gecode::ReifiableConstraint do
  before do
    @model = ReifSugarSampleProblem.new
    @x = @model.x
    @y = @model.y
    @z = @model.z
  end

  it 'should fail disjunctions if neither side can be satisfied' do
    (@x.must == 3) | (@y.must == 3)
    lambda{ @model.solve! }.should raise_error(Gecode::NoSolutionError)
  end
  
  it 'should solve disjunctions' do
    (@x.must > 0) | (@y.must == 3)
    sol = @model.solve!
    sol.should_not be_nil
    sol.x.should have_domain([1])
  end
  
  it 'should fail conjunctions if one side can\'t be satisfied' do
    (@x.must > 3) & (@y.must == 3)
    lambda{ @model.solve! }.should raise_error(Gecode::NoSolutionError)
  end

  it 'should solve conjunctions' do
    (@x.must > 0) & (@y.must == 2)
    sol = @model.solve!
    sol.should_not be_nil
    sol.x.should have_domain([1])
    sol.y.should have_domain([2])
  end

  it 'should handle the same variable being used multiple times' do
    (@z.must == 4) | (@z.must == 4)
    sol = @model.solve!
    sol.should_not be_nil
    sol.z.should have_domain([4])
  end
  
  it 'should handle nested operations' do
    ((@x.must > 3) & (@y.must == 2)) | (@z.must == 4) | (
      (@x.must == 0) & (@z.must == 4))
    sol = @model.solve!
    sol.should_not be_nil
    sol.x.should have_domain([0])
    sol.z.should have_domain([4])
  end
  
  it 'should handle negations' do
    (@z.must_not == 4) & (@z.must == 4)
    lambda{ @model.solve! }.should raise_error(Gecode::NoSolutionError)
  end
end
