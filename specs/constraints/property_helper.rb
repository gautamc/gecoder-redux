require File.dirname(__FILE__) + '/../spec_helper'

# Every property should have a spec that specs the following:
#
# * An example where the property is used to constrain a sample problem.
# * should_behave_like foo operand
# * A test that the property is translated to the correct Gecode
# constraint if deemed necessary.

# Several of these shared specs requires one or more of the following instance 
# variables to be used: 
# [@operand]  The operand that is being tested.
# [@model]    The model that defines the context in which the test is
#             conducted.
# [@property_types]  An array of symbols signaling what types of
#                    arguments @select_property accepts. The symbols
#                    must be one of: :int, :bool, :set, :int_enum,
#                    :bool_enum, :set_enum, :fixnum_enum.
# [@select_property] A proc that selects the property under test. It
#                    should take at least one argument: the operand that
#                    the property should be selected from.
# [@selected_property] The resulting operand of the property. It should
#                      be constrained to the degree that it has a
#                      non-maximal domain.
# [@constraint_class] The class of the constraints that are expected to be
#                     produced when a constraint is short circuited.
#


# Requires @operand and @model.
describe 'int var operand', :shared => true do
  it 'should implement #model' do
    @operand.model.should be_kind_of(Gecode::Mixin)
  end

  it 'should implement #to_int_var' do
    int_var = @operand.to_int_var
    int_var.should be_kind_of(Gecode::IntVar)
    @model.solve!
    (int_var.min..int_var.max).should_not equal(Gecode::Mixin::LARGEST_INT_DOMAIN)
  end

  it 'should implement #must' do
    receiver = @operand.must
    receiver.should be_kind_of(
      Gecode::Int::IntConstraintReceiver)
  end
end

# Requires @operand and @model.
describe 'bool var operand', :shared => true do
  it 'should implement #model' do
    @operand.model.should be_kind_of(Gecode::Mixin)
  end

  it 'should implement #to_bool_var' do
    bool_var = @operand.to_bool_var
    bool_var.should be_kind_of(Gecode::BoolVar)
  end

  it 'should implement #must' do
    receiver = @operand.must
    receiver.should be_kind_of(
      Gecode::Bool::BoolConstraintReceiver)
  end
end

# Requires @operand and @model.
describe 'set var operand', :shared => true do
  it 'should implement #model' do
    @operand.model.should be_kind_of(Gecode::Mixin)
  end

  it 'should implement #to_set_var' do
    set_var = @operand.to_set_var
    set_var.should be_kind_of(Gecode::SetVar)
    @model.solve!
    ((set_var.lower_bound == []) && 
     (set_var.upper_bound == Gecode::Mixin::LARGEST_SET_BOUND)).should_not(
      be_true)
  end

  it 'should implement #must' do
    receiver = @operand.must
    receiver.should be_kind_of(
      Gecode::Set::SetConstraintReceiver)
  end
end

# Requires @model, @property_types and @select_property.
describe 'property that produces operand', :shared => true do
  it 'should raise errors if parameters of the incorrect type are given' do
    operands, variables = produce_general_arguments(@property_types)
    (1...operands.size).each do |i|
      bogus_operands = operands.clone
      bogus_operands[i] = Object.new
      lambda do
        @select_property.call(*bogus_operands)
      end.should raise_error(TypeError)
    end
  end
end

# Requires @model, @property_types and @select_property.
describe 'property that produces int operand', :shared => true do
  it 'should produce int operand' do
    operands, variables = produce_general_arguments(@property_types)
    operand = @select_property.call(*operands)

    # Test the same invariants as in the test for int var operands.
    operand.model.should be_kind_of(Gecode::Mixin)

    int_var = operand.to_int_var
    int_var.should be_kind_of(Gecode::IntVar)

    receiver = operand.must
    receiver.should be_kind_of(
      Gecode::Int::IntConstraintReceiver)
  end

  it_should_behave_like 'property that produces operand'
end

# Requires @model, @property_types and @select_property.
describe 'property that produces bool operand', :shared => true do
  it 'should produce bool operand' do
    operands, variables = produce_general_arguments(@property_types)
    operand = @select_property.call(*operands)

    # Test the same invariants as in the test for bool var operands.
    operand.model.should be_kind_of(Gecode::Mixin)

    bool_var = operand.to_bool_var
    bool_var.should be_kind_of(Gecode::BoolVar)

    receiver = operand.must
    receiver.should be_kind_of(
      Gecode::Bool::BoolConstraintReceiver)
  end

  it_should_behave_like 'property that produces operand'
end

# Requires @model, @property_types and @select_property.
describe 'property that produces set operand', :shared => true do
  it 'should produce set operand' do
    operands, variables = produce_general_arguments(@property_types)
    operand = @select_property.call(*operands)

    # Test the same invariants as in the test for int var operands.
    operand.model.should be_kind_of(Gecode::Mixin)

    set_var = operand.to_set_var
    set_var.should be_kind_of(Gecode::SetVar)

    receiver = operand.must
    receiver.should be_kind_of(
      Gecode::Set::SetConstraintReceiver)
  end

  it_should_behave_like 'property that produces operand'
end

# Requires @model, @constraint_class, @property_types, @select_property and
# @selected_property.
#
# These properties should only short circuit equality when there is no
# negation nor reification and the right hand side is an int operand.
describe 'property that produces int operand by short circuiting equality', :shared => true do
  it 'should produce constraints when short circuited' do
    @constraint_class.superclass.should == Gecode::Constraint
  end

  it 'should give the same solution regardless of whether short circuit was used' do
    int_operand = @selected_property
    direct_int_var = int_operand.to_int_var
    indirect_int_op, _ = general_int_operand(@model)
    @selected_property.must == indirect_int_op
    @model.solve!

    direct_int_var.should_not have_domain(Gecode::Mixin::LARGEST_INT_DOMAIN)
    direct_int_var.should have_domain(indirect_int_op.domain)
  end

  it 'should short circuit equality' do
    (@selected_property.must == @model.int_var).should(
      be_kind_of(@constraint_class))
  end

  it 'should not short circuit when negation is used' do
    (@selected_property.must_not == @model.int_var).should_not(
      be_kind_of(@constraint_class))
  end

  it 'should not short circuit when reification is used' do
    @selected_property.must.equal(@model.int_var, 
      :reify => @model.bool_var).should_not(be_kind_of(@constraint_class))
  end

  it 'should not short circuit when the right hand side is not a operand' do
    @selected_property.must.equal(2).should_not(be_kind_of(@constraint_class))
  end

  it 'should not short circuit when equality is not used' do
    (@selected_property.must > @model.int_var).should_not(
      be_kind_of(@constraint_class))
  end

  it 'should raise error when the right hand side is of illegal type' do
    lambda do
      @selected_property.must == 'foo'
    end.should raise_error(TypeError)
  end

  it_should_behave_like 'property that produces int operand'
end

# Requires @model, @constraint_class, @property_types, @select_property and
# @selected_property.
#
# These properties should only short circuit equality when there is no
# negation nor reification and the right hand side is a bool operand.
describe 'property that produces bool operand by short circuiting equality', :shared => true do
  it 'should produce constraints when short circuited' do
    @constraint_class.superclass.should == Gecode::Constraint
  end

  it 'should give the same solution regardless of whether short circuit was used' do
    bool_operand = @selected_property
    direct_bool_var = bool_operand.to_bool_var
    indirect_bool_var = @model.bool_var
    @selected_property.must == indirect_bool_var
    @model.solve!

    direct_bool_var.value.should == indirect_bool_var.value
  end

  it 'should short circuit equality' do
    (@selected_property.must == @model.bool_var).should(
      be_kind_of(@constraint_class))
  end

  it 'should not short circuit when negation is used' do
    (@selected_property.must_not == @model.bool_var).should_not(
      be_kind_of(@constraint_class))
  end

  it 'should not short circuit when reification is used' do
    @selected_property.must.equal(@model.bool_var, 
      :reify => @model.bool_var).should_not(be_kind_of(@constraint_class))
  end

  it 'should not short circuit when equality is not used' do
    (@selected_property.must.imply @model.bool_var).should_not(
      be_kind_of(@constraint_class))
  end

  it 'should raise error when the right hand side is of illegal type' do
    lambda do
      @selected_property.must == 'foo'
    end.should raise_error(TypeError)
  end

  it_should_behave_like 'property that produces bool operand'
end

# Requires @model, @constraint_class, @property_types and @select_property.
# 
# These properties should short circuit all comparison relations
# even when negated and when fixnums are used as right hand side.
describe 'property that produces int operand by short circuiting relations', :shared => true do
  it 'should produce reifiable constraints when short circuited' do
    @constraint_class.superclass.should == 
      Gecode::ReifiableConstraint
  end

  Gecode::Util::RELATION_TYPES.keys.each do |relation|
    it "should give the same solution regardless of whether short circuit #{relation} was used" do
      direct_int_var = @model.int_var
      @selected_property.to_int_var.must.method(relation).call direct_int_var
      indirect_int_var = @model.int_var
      @selected_property.must.method(relation).call indirect_int_var
      @model.solve!

      direct_int_var.should_not have_domain(Gecode::Mixin::LARGEST_INT_DOMAIN)
      direct_int_var.should have_domain(indirect_int_var.domain)
    end

    it "should short circuit #{relation}" do
      (@selected_property.must.method(relation).call @model.int_var).should(
        be_kind_of(@constraint_class))
    end

    it "should short circuit negated #{relation}" do
      (@selected_property.must_not.method(relation).call @model.int_var).should(
        be_kind_of(@constraint_class))
    end

    it "should short circuit #{relation} when reification is used" do
      (@selected_property.must.method(relation).call(@model.int_var, 
        :reify => @model.bool_var)).should(be_kind_of(@constraint_class))
    end

    it "should short circuit #{relation} even when the right hand side is a fixnum" do
      (@selected_property.must.method(relation).call 2).should(
        be_kind_of(@constraint_class))
    end

    it "should raise error when the #{relation} right hand side is of illegal type" do
      lambda do
        @selected_property.must.method(relation).call('foo')
      end.should raise_error(TypeError)
    end
  end

  it_should_behave_like 'property that produces int operand'
end

# Requires @model, @constraint_class, @property_types, @select_property and
# @selected_property.
#
# These properties should only short circuit equality when there is no
# negation nor reification and the right hand side is a set operand.
describe 'property that produces set operand by short circuiting equality', :shared => true do
  it 'should produce constraints when short circuited' do
    @constraint_class.superclass.should == Gecode::Constraint
  end

  it 'should give the same solution regardless of whether short circuit was used' do
    set_operand = @selected_property
    direct_set_var = set_operand.to_set_var
    indirect_set_var = @model.set_var
    @selected_property.must == indirect_set_var
    @model.solve!

    direct_set_var.should have_bounds(indirect_set_var.lower_bound, 
      indirect_set_var.upper_bound)
  end

  it 'should short circuit equality' do
    (@selected_property.must == @model.set_var).should(
      be_kind_of(@constraint_class))
  end

  it 'should not short circuit when negation is used' do
    (@selected_property.must_not == @model.set_var).should_not(
      be_kind_of(@constraint_class))
  end

  it 'should not short circuit when reification is used' do
    (@selected_property.must.equal(@model.set_var, 
      :reify => @model.bool_var)).should_not(be_kind_of(@constraint_class))
  end

  it 'should not short circuit when the right hand side is not a operand' do
    (@selected_property.must == [1,3,5]).should_not(
      be_kind_of(@constraint_class))
  end

  it 'should not short circuit when equality is not used' do
    (@selected_property.must_be.subset_of(@model.set_var)).should_not(
      be_kind_of(@constraint_class))
  end

  it 'should raise error when the right hand side is of illegal type' do
    lambda do
      @selected_property.must == 'foo'
    end.should raise_error(TypeError)
  end

  it_should_behave_like 'property that produces set operand'
end

# Requires @model, @constraint_class, @property_types and @select_property.
# 
# These properties should only short circuit set relations when neither
# negation nor reification is used (both for constant sets and set
# variables). 
describe 'property that produces set operand by short circuiting set relations', :shared => true do
  Gecode::Util::SET_RELATION_TYPES.keys.each do |relation|
    it 'should produce constraints when short circuited' do
      @constraint_class.superclass.should == Gecode::Constraint
    end

    it "should give the same solution regardless of whether short circuit #{relation} was used" do
      if relation == :complement
        direct_set_var, indirect_set_var = Array.new(2){ @model.set_var }
      else
        direct_set_var, indirect_set_var = Array.new(2) do
          @model.set_var([], -1000..1000)
        end
      end

      @selected_property.to_set_var.must.method(relation).call direct_set_var
      @selected_property.must.method(relation).call indirect_set_var
      @model.solve!

      if relation == :complement
        direct_set_var.upper_bound.min.should == 
          indirect_set_var.upper_bound.min
        direct_set_var.upper_bound.max.should == 
          indirect_set_var.upper_bound.max
        direct_set_var.lower_bound.min.should ==
          indirect_set_var.lower_bound.min
        direct_set_var.lower_bound.max.should == 
          indirect_set_var.lower_bound.max
        direct_set_var.lower_bound.size.should == 
          indirect_set_var.lower_bound.size
      else
        direct_set_var.should have_bounds(indirect_set_var.lower_bound, 
          indirect_set_var.upper_bound)
      end
    end

    it "should short circuit #{relation}" do
      @selected_property.must.method(relation).call(@model.set_var).should( 
        be_kind_of(@constraint_class))
    end

    it "should not short circuit negated #{relation}" do
      @selected_property.must_not.method(relation).call(
        @model.set_var).should_not(be_kind_of(@constraint_class))
    end
    
    it "should not short circuit reified #{relation}" do
      @selected_property.must.method(relation).call(@model.set_var, 
        :reify => @model.bool_var).should_not(be_kind_of(@constraint_class))
    end

    it "should short circuit #{relation} even when the right hand side is a constant set" do
      @selected_property.must.method(relation).call([1, 2, 3]).should( 
        be_kind_of(@constraint_class))
    end

    it "should raise error when the #{relation} right hand side is of illegal type" do
      lambda do
        @selected_property.must.method(relation).call('foo')
      end.should raise_error(TypeError)
    end
  end

  it_should_behave_like 'property that produces set operand'
end
