require File.dirname(__FILE__) + '/../spec_helper'

describe 'constraint receiver', :shared => true do
  it 'should raise error unless an operand of the correct type is given as lhs' do
    lambda do
      op = Object.new
      class <<op
        include Gecode::Operand
      end
      @receiver.new(@model, {:lhs => op, :negate => false})
    end.should raise_error(TypeError)
  end
end

describe Gecode::ConstraintReceiver do
  before do
    @model = Gecode::Model.new
  end

  it 'should raise error if the negate params is not given' do
    lambda do
      Gecode::ConstraintReceiver.new(@model, {:lhs => nil})
    end.should raise_error(ArgumentError)
  end
    
  it 'should raise error if the lhs params is not given' do
    lambda do
      Gecode::ConstraintReceiver.new(@model, {:lhs => nil})
    end.should raise_error(ArgumentError)
  end
end

describe Gecode::Int::IntConstraintReceiver, ' (not subclassed)' do
  before do
    @model = Gecode::Model.new
    @receiver = Gecode::Int::IntConstraintReceiver
  end

  it_should_behave_like 'constraint receiver'
end

describe Gecode::IntEnum::IntEnumConstraintReceiver do
  before do
    @model = Gecode::Model.new
    @receiver = Gecode::IntEnum::IntEnumConstraintReceiver
  end

  it_should_behave_like 'constraint receiver'
end

describe Gecode::Bool::BoolConstraintReceiver do
  before do
    @model = Gecode::Model.new
    @receiver = Gecode::Bool::BoolConstraintReceiver
  end

  it_should_behave_like 'constraint receiver'
end

describe Gecode::BoolEnum::BoolEnumConstraintReceiver do
  before do
    @model = Gecode::Model.new
    @receiver = Gecode::BoolEnum::BoolEnumConstraintReceiver
  end

  it_should_behave_like 'constraint receiver'
end

describe Gecode::Set::SetConstraintReceiver do
  before do
    @model = Gecode::Model.new
    @receiver = Gecode::Set::SetConstraintReceiver
  end

  it_should_behave_like 'constraint receiver'
end

describe Gecode::SelectedSet::SelectedSetConstraintReceiver do
  before do
    @model = Gecode::Model.new
    @receiver = Gecode::SelectedSet::SelectedSetConstraintReceiver
  end

  it_should_behave_like 'constraint receiver'
end

describe Gecode::SetElements::SetElementsConstraintReceiver do
  before do
    @model = Gecode::Model.new
    @receiver = Gecode::SetElements::SetElementsConstraintReceiver
  end

  it_should_behave_like 'constraint receiver'
end

describe Gecode::SetEnum::SetEnumConstraintReceiver do
  before do
    @model = Gecode::Model.new
    @receiver = Gecode::SetEnum::SetEnumConstraintReceiver
  end

  it_should_behave_like 'constraint receiver'
end
