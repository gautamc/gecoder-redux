require File.dirname(__FILE__) + '/../property_helper'

class FixnumElementSampleProblem
  include Gecode::Mixin

  attr :prices
  attr :store
  attr :price
  
  def initialize
    prices = [17, 63, 45, 63]
    @prices = wrap_enum(prices)
    @store = int_var(0...prices.size)
    @price = int_var(prices)
    branch_on @store
  end
end

describe Gecode::FixnumEnum::Element do
  before do
    @model = FixnumElementSampleProblem.new
    @price = @model.price
    @store = @model.store
    @enum = @model.prices
    
    # For int operand producing property spec.
    @property_types = [:fixnum_enum, :int]
    @select_property = lambda do |fixnum_enum, int|
      fixnum_enum[int]
    end
    @selected_property = @enum[@store]
    @constraint_class = Gecode::BlockConstraint
  end

  it 'should not disturb normal array access' do
    @enum[2].should_not be_nil
  end

  it 'should constrain the selected element' do
    @enum[@store].must == @enum[2]
    @model.solve!.should_not be_nil
    @store.value.should equal(2)
  end

  it 'should be translated into an element constraint' do
    @enum[@store].must == @price
    @model.allow_space_access do
      Gecode::Raw.should_receive(:element).once.with( 
        an_instance_of(Gecode::Raw::Space), 
        an_instance_of(Array), 
        @store.bind, @price.bind, 
        Gecode::Raw::ICL_DEF,
        Gecode::Raw::PK_DEF)
    end
    @model.solve!
  end
  
  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end
