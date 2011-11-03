require File.dirname(__FILE__) + '/../property_helper'

class ElementSampleProblem
  include Gecode::Mixin

  attr :prices
  attr :store
  attr :price
  attr :fixnum_prices
  
  def initialize
    prices = [17, 63, 45, 63]
    @fixnum_prices = wrap_enum(prices)
    @prices = int_var_array(4, prices)
    @store = int_var(0...prices.size)
    @price = int_var(prices)
    branch_on @store
  end
end

describe Gecode::IntEnum::Element do
  before do
    @model = ElementSampleProblem.new
    @prices = @model.prices
    @target = @price = @model.price
    @store = @model.store
    
    # For int operand producing property spec.
    @property_types = [:int_enum, :int]
    @select_property = lambda do |int_enum, int|
      int_enum[int]
    end
    @selected_property = @prices[@store]
    @constraint_class = Gecode::BlockConstraint
  end

  it 'should not disturb normal array access' do
    @prices[2].should_not be_nil
  end

  it 'should constrain the selected element' do
    @prices[@store].must == 63
    @prices.values_at(0,2,3).each{ |x| x.must < 50 }
    @model.solve!.should_not be_nil
    @store.value.should equal(1)
  end

  it 'should be translated into an element constraint' do
    @prices[@store].must == @price
    @model.allow_space_access do
      Gecode::Raw.should_receive(:element).once.with( 
        an_instance_of(Gecode::Raw::Space), 
        an_instance_of(Gecode::Raw::IntVarArray), 
        @store.bind, @price.bind, 
        Gecode::Raw::ICL_DEF,
        Gecode::Raw::PK_DEF)
    end
    @model.solve!
  end
  
  it_should_behave_like(
    'property that produces int operand by short circuiting equality')
end
