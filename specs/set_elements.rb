require File.dirname(__FILE__) + '/spec_helper'

describe Gecode::SelectedSet::SelectedSetOperand do
  before do
    @model = Gecode::Model.new
    @set = @model.set_var([], 0..4)
    @operand = Gecode::SetElements::SetElementsOperand.new(@set)
  end

  it 'should implement #model' do
    @operand.model.should be_kind_of(Gecode::Mixin)
  end

  it 'should implement #to_set_elements' do
    set = @operand.to_set_elements
    set.should be_respond_to(:to_set_var)
    @model.solve!
    set_var = set.to_set_var
    ((set_var.lower_bound == []) && 
     (set_var.upper_bound == Gecode::Mixin::LARGEST_SET_BOUND)).should_not(
      be_true)
  end

  it 'should implement #must' do
    receiver = @operand.must
    receiver.should be_kind_of(
      Gecode::SetElements::SetElementsConstraintReceiver)
  end

  it 'should be produces by SetOperand#elements' do
    @set.elements.should be_respond_to(:to_set_elements)
  end
end

