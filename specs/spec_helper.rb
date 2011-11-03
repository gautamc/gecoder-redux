require 'rubygems'
require 'spec'
require File.dirname(__FILE__) + '/../lib/gecoder'

module CustomVarMatchers
  class HaveDomain
    def initialize(expected)
      @expected = expected
    end
    
    def matches?(target)
      @target = target
      if @expected.kind_of? Range
        last = @expected.end
        last -= 1 if @expected.exclude_end?
        return @target.range? && @expected.begin == @target.min && 
          last == @target.max
      else
        @expected = @expected.to_a
        return false unless @target.size == @expected.size
        @expected.each do |element|
          return false unless @target.include? element
        end
        return true
      end
      return false
    end
    
    def failure_message
      "expected #{@target.inspect} to have domain #{@expected.inspect}"
    end
    
    def negative_failure_message
      "expected #{@target.inspect} not to have domain #{@expected.inspect}"
    end
  end

  # Tests whether a variable has the expected domain.
  def have_domain(expected)
    HaveDomain.new(expected)
  end
  
  class HaveBounds
    def initialize(expected_glb, expected_lub)
      @expected_glb = expected_glb.to_a
      @expected_lub = expected_lub.to_a
    end
    
    def matches?(target)
      @target = target
      return @target.lower_bound.size == @expected_glb.size &&
        @target.upper_bound.size == @expected_lub.size &&
        @target.lower_bound.to_a == @expected_glb &&
        @target.upper_bound.to_a == @expected_lub
    end
    
    def failure_message
      "expected #{@target.inspect} to have greatest lower bound " + 
        "#{@expected_glb.inspect} and least upper bound #{@expected_lub.inspect}"
    end
    
    def negative_failure_message
      "expected #{@target.inspect} to not have greatest lower bound " + 
        "#{@expected_glb.inspect} and least upper bound #{@expected_lub.inspect}"
    end
  end

  # Tests whether a set variable has the expected bounds.
  def have_bounds(expected_glb, expected_lub)
    HaveBounds.new(expected_glb, expected_lub)
  end
end

Spec::Runner.configure do |config|
  config.include(CustomVarMatchers)
end


# Help methods for the GecodeR specs. 
module GecodeR::Specs
  module SetHelper
    module_function
  
    # Returns the arguments that should be used in a partial mock to expect the
    # specified constant set (possibly an array of arguments).
    def expect_constant_set(constant_set)
      if constant_set.kind_of? Range
        return constant_set.first, constant_set.last
      elsif constant_set.kind_of? Fixnum
        constant_set
      else
        an_instance_of(Gecode::Raw::IntSet)
      end
    end
  end

  module GeneralHelper
    module_function

    # Produces a base operand that can be used to mock specific types of
    # operands.
    def general_operand_base(model)
      mock_op_class = Class.new
      mock_op_class.class_eval do
        attr :model

        def bind
          raise 'Bind should not be called directly for an operand.'
        end
        alias_method :bind_array, :bind
      end
      op = mock_op_class.new
      op.instance_eval do
        @model = model
      end
      return op
    end

    # Produces a general int operand. The method returns two objects: 
    # the operand itself and the variable it returns when #to_int_var
    # is called.
    def general_int_operand(model)
      op = general_operand_base(model)
      
      int_var = model.int_var
      class <<op
        include Gecode::Int::IntOperand
        attr :model
      end
      op.stub!(:to_int_var).and_return int_var

      return op, int_var
    end

    # Produces a general bool operand. The method returns two objects: 
    # the operand itself and the variable it returns when #to_bool_var
    # is called.
    def general_bool_operand(model)
      op = general_operand_base(model)

      bool_var = model.bool_var
      class <<op
        include Gecode::Bool::BoolOperand
        attr :model
      end
      op.stub!(:to_bool_var).and_return bool_var

      return op, bool_var
    end

    # Produces a general set operand. The method returns two objects: 
    # the operand itself and the variable it returns when #to_set_var
    # is called.
    def general_set_operand(model)
      op = general_operand_base(model)

      set_var = model.set_var
      class <<op
        include Gecode::Set::SetOperand
        attr :model
      end
      op.stub!(:to_set_var).and_return set_var

      return op, set_var
    end
    
    # Produces a general int enum operand. The method returns two objects: 
    # the operand itself and the variable it returns when #to_int_enum
    # is called.
    def general_int_enum_operand(model)
      op = general_operand_base(model)
      
      int_enum = model.int_var_array(5)
      class <<op
        include Gecode::IntEnum::IntEnumOperand
        attr :model
      end
      op.stub!(:to_int_enum).and_return int_enum

      return op, int_enum
    end

    # Produces a general bool enum operand. The method returns two objects: 
    # the operand itself and the variable it returns when #to_bool_enum
    # is called.
    def general_bool_enum_operand(model)
      op = general_operand_base(model)
      
      bool_enum = model.bool_var_array(5)
      class <<op
        include Gecode::BoolEnum::BoolEnumOperand
        attr :model
      end
      op.stub!(:to_bool_enum).and_return bool_enum

      return op, bool_enum
    end

    # Produces a general set enum operand. The method returns two objects: 
    # the operand itself and the variable it returns when #to_set_enum
    # is called.
    def general_set_enum_operand(model)
      op = general_operand_base(model)
      
      set_enum = model.set_var_array(5)
      class <<op
        include Gecode::SetEnum::SetEnumOperand
        attr :model
      end
      op.stub!(:to_set_enum).and_return set_enum

      return op, set_enum
    end

    # Produces a general selected set operand. The method returns two objects: 
    # the operand itself and the array of variables corresponding to the
    # operands it returns when # #to_selected_set is called.
    def general_selected_set_operand(model)
      set_enum, set_enum_var = general_set_enum_operand(model)
      set, set_var = general_set_operand(model)
      op = Gecode::SelectedSet::SelectedSetOperand.new(
        set_enum, set)
      return op, [set_enum_var, set_var]
    end

    # Produces a general set elements  operand. The method returns two 
    # objects: the operand itself and the set var corresponding to the
    # operands it returns when # #to_selected_set is called.
    def general_set_elements_operand(model)
      set, set_var = general_set_operand(model)
      op = Gecode::SetElements::SetElementsOperand.new(set)
      return op, set_var
    end

    # Produces a general fixnum enum operand. The method returns two objects: 
    # the operand itself and the variable it returns when #to_fixnum_enum
    # is called.
    def general_fixnum_enum_operand(model)
      op = general_operand_base(model)
      
      fixnum_enum = model.wrap_enum([1, -4, 9, 4, 0])
      class <<op
        include Gecode::FixnumEnum::FixnumEnumOperand
        attr :model
      end
      op.stub!(:to_fixnum_enum).and_return fixnum_enum

      return op, fixnum_enum
    end

    # Produces an array of general operands of the specified types.
    # Returns an array of operands and an array of their variables.
    def produce_general_arguments(property_types)
      operands = []
      variables = []
      property_types.each do |type|
        op, var = eval "general_#{type}_operand(@model)"
        operands << op
        variables << var
      end
      return operands, variables
    end
  end
end
include GecodeR::Specs::GeneralHelper
