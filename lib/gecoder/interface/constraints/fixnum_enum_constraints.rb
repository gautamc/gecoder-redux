# A module containing constraints that have enumerations of instances of
# Fixnum as left hand side.
module Gecode::FixnumEnum #:nodoc:
  # A FixnumEnumOperand is a enumeration of Fixnum on which the
  # constraints defined in FixnumEnumConstraintReceiver can be placed.
  # They typically service as constant arrays or constant sets.
  #
  # The fixnum enumeration operands are created by wrapping an enumeration 
  # of fixnum Gecode::Mixin#wrap_enum. The enumerations created that way
  # all respond to the properties defined by FixnumEnumOperand.
  #
  # ==== Examples 
  #
  # Uses Gecode::Mixin#wrap_enum inside a problem formulation to create
  # a FixnumEnumOperand from an existing enumeration of Fixnum:
  #
  #   fixnum_enum = wrap_enum([3, 5, 7])
  #   
  #--
  # Classes that mix in FixnumEnumOperand must define #model.
  module FixnumEnumOperand
    include Gecode::Operand 

    def method_missing(method, *args) #:nodoc:
      if Gecode::FixnumEnum::Dummy.instance_methods.include? method.to_s
        # Delegate to the fixnum enum.
        to_fixnum_enum.method(method).call(*args)
      else
        super
      end
    end

    private
  
    def construct_receiver(params)
      raise NotImplementedError, 'Fixnum enums do not have constraints.'
    end
  end
end

require 'gecoder/interface/constraints/fixnum_enum/element'
require 'gecoder/interface/constraints/fixnum_enum/operation'
