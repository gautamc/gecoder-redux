require File.dirname(__FILE__) + '/../property_helper'

[:&, :|, :^].each do |property|
  describe Gecode::Bool, " (#{property} property)" do
    before do
      @model = Gecode::Model.new
      @b1 = @model.bool_var
      @b2 = @model.bool_var
      @model.branch_on @model.wrap_enum([@b1, @b2])

      # For bool operand producing property spec.
      @property_types = [:bool, :bool]
      @select_property = lambda do |bool1, bool2|
        bool1.method(property).call bool2
      end
      @selected_property = @b1.method(property).call @b2
    end

    it 'should constrain the conjunction/disjunction/exclusive disjunction' do
      (@b1.method(property).call @b2).must_be.true
      @model.solve!
      @b1.value.method(property).call(@b2.value).should be_true
    end

    it_should_behave_like 'property that produces bool operand'
  end
end

describe Gecode::Bool, ' (#implies property)' do
  before do
    @model = Gecode::Model.new
    @b1 = @model.bool_var
    @b2 = @model.bool_var
    @model.branch_on @model.wrap_enum([@b1, @b2])

    # For bool operand producing property spec.
    @property_types = [:bool, :bool]
    @select_property = lambda do |bool1, bool2|
      bool1.implies bool2
    end
    @selected_property = @b1.implies @b2
  end

  it 'should constrain the implication' do
    (@b1.implies @b2).must_be.true
    @model.solve!
    (!@b1.value | @b2.value).should be_true
  end

  it_should_behave_like 'property that produces bool operand'
end
