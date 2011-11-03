# A module containing constraints that have enumerations of boolean 
# operands as left hand side.
module Gecode::BoolEnum #:nodoc:
  # A BoolEnumOperand is a enumeration of BoolOperand on which the
  # constraints defined in BoolEnumConstraintReceiver can be placed.
  #
  # Enumerations of boolean operands can be created either by using
  # Gecode::Mixin#bool_var_array and Gecode::Mixin#bool_var_matrix, or
  # by wrapping an existing enumeration containing BoolOperand using
  # Gecode::Mixin#wrap_enum. The enumerations, no matter how they were
  # created, all respond to the properties defined by BoolEnumOperand.
  #
  # ==== Examples 
  #
  # Produces an array of five boolean operands inside a problem formulation
  # using Gecode::Mixin#bool_var_array:
  #
  #   bool_enum = bool_var_array(5)
  #
  # Uses Gecode::Mixin#wrap_enum inside a problem formulation to create
  # a BoolEnumOperand from an existing enumeration containing the
  # boolean operands +bool_operand1+ and +bool_operand2+:
  #
  #   bool_enum = wrap_enum([bool_operand1, bool_operand2])
  #   
  #--
  # Classes that mix in BoolEnumOperand must define #model and
  # #to_bool_enum .
  module BoolEnumOperand
    include Gecode::Operand 

    def method_missing(method, *args) #:nodoc:
      if Gecode::BoolEnum::Dummy.instance_methods.include? method.to_s
        # Delegate to the bool enum.
        to_bool_enum.method(method).call(*args)
      else
        super
      end
    end

    private

    def construct_receiver(params)
      BoolEnumConstraintReceiver.new(@model, params)
    end
  end

  # BoolEnumConstraintReceiver contains all constraints that can be
  # placed on a BoolEnumOperand.
  #
  # Constraints are placed by calling BoolEnumOperand#must (or any other
  # of the variations defined in Operand), which produces a
  # BoolEnumConstraintReceiver from which the desired constraint can be
  # used.
  #
  # ==== Examples 
  #
  # Constrains +bool_enum+, with three boolean operands, to take the 
  # value of the tuples [false, true, false] or [true, false, true] 
  # using BoolEnumConstraintReceiver#in:
  #
  #   bool_enum.must_be.in [[false, true, false], [true, false, true]]
  #
  # Constrains +bool_enum+ to channel +int_operand+ using 
  # BoolEnumConstraintReceiver#channel:
  #
  #   bool_enum.must.channel int_operand
  #
  class BoolEnumConstraintReceiver < Gecode::ConstraintReceiver
    # Raises TypeError unless the left hand side is an bool enum
    # operand.
    def initialize(model, params) #:nodoc:
      super

      unless params[:lhs].respond_to? :to_bool_enum
        raise TypeError, 'Must have bool enum operand as left hand side.'
      end
    end
  end
end

require 'gecoder/interface/constraints/bool_enum/relation'
require 'gecoder/interface/constraints/bool_enum/extensional'
require 'gecoder/interface/constraints/bool_enum/channel'
