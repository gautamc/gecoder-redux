# A module containing constraints that have enumerations of integer 
# operands as left hand side.
module Gecode::IntEnum #:nodoc:
  # A IntEnumOperand is a enumeration of IntOperand on which the
  # constraints defined in IntEnumConstraintReceiver can be placed.
  #
  # Enumerations of integer operands can be created either by using
  # Gecode::Mixin#int_var_array and Gecode::Mixin#int_var_matrix, or
  # by wrapping an existing enumeration containing IntOperand using
  # Gecode::Mixin#wrap_enum. The enumerations, no matter how they were
  # created, all respond to the properties defined by IntEnumOperand.
  #
  # ==== Examples 
  #
  # Produces an array of five int operands with domain 0..9 inside a 
  # problem formulation using Gecode::Mixin#int_var_array:
  #
  #   int_enum = int_var_array(5, 0..9)
  #
  # Uses Gecode::Mixin#wrap_enum inside a problem formulation to create
  # a IntEnumOperand from an existing enumeration containing the
  # integer operands +int_operand1+ and +int_operand2+:
  #
  #   int_enum = wrap_enum([int_operand1, int_operand2])
  #   
  #--
  # Classes that mix in IntEnumOperand must define #model and
  # #to_int_enum .
  module IntEnumOperand
    include Gecode::Operand 

    def method_missing(method, *args) #:nodoc:
      if Gecode::IntEnum::Dummy.instance_methods.include? method.to_s
        # Delegate to the int enum.
        to_int_enum.method(method).call(*args)
      else
        super
      end
    end

    private

    def construct_receiver(params)
      IntEnumConstraintReceiver.new(@model, params)
    end
  end

  # IntEnumConstraintReceiver contains all constraints that can be
  # placed on a IntEnumOperand.
  #
  # Constraints are placed by calling IntEnumOperand#must (or any other
  # of the variations defined in Operand), which produces a 
  # IntEnumConstraintReceiver from which the desired constraint can be used.
  #
  # Some constraint accepts a number of options. See ConstraintReceiver
  # for more information.
  #
  # ==== Examples 
  #
  # Constrains the integer operands in +int_enum+ to take on different
  # values by using IntEnumConstraintReceiver#distinct:
  #
  #   int_enum.must_be.distinct
  #
  # Constrains +int_enum2+ to have the same elements as +int_enum+, but
  # sorted in ascending order. Uses IntEnumConstraintReceiver#sorted:
  #
  #   int_enum.must_be.sorted(:as => int_enum2)
  #
  # The same as above, but specifying that strength :domain should be 
  # used and that the constraint should be reified with +bool_operand+:
  #
  #   int_enum.must_be.sorted(:as => int_enum2, :strength => :domain, :reify => bool_operand)
  #
  class IntEnumConstraintReceiver < Gecode::ConstraintReceiver
    # Raises TypeError unless the left hand side is an int enum
    # operand.
    def initialize(model, params) #:nodoc:
      super

      unless params[:lhs].respond_to? :to_int_enum
        raise TypeError, 'Must have int enum operand as left hand side.'
      end
    end
  end
end

require 'gecoder/interface/constraints/int_enum/distinct'
require 'gecoder/interface/constraints/int_enum/equality'
require 'gecoder/interface/constraints/int_enum/channel'
require 'gecoder/interface/constraints/int_enum/element'
require 'gecoder/interface/constraints/int_enum/count'
require 'gecoder/interface/constraints/int_enum/sort'
require 'gecoder/interface/constraints/int_enum/arithmetic'
require 'gecoder/interface/constraints/int_enum/extensional'
