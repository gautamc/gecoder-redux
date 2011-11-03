module Gecode::SetEnum
  module SetEnumOperand
    # Produces a SetOperand representing the union of all sets in this
    # enumeration.
    #
    # ==== Examples 
    #
    #   # The union of all sets in +set_enum+.
    #   set_enum.union
    def union
      set_operation(:union)
    end
    
    # Produces a SetOperand representing the intersection of all sets in this
    # enumeration.
    #
    # ==== Examples 
    #
    #   # The intersection of all sets in +set_enum+.
    #   set_enum.intersection
    def intersection
      set_operation(:intersection)
    end

    # Produces a SetOperand representing the disjoint union of all sets 
    # in this enumeration.
    #
    # ==== Examples 
    #
    #   # The disjoint union of all sets in +set_enum+.
    #   set_enum.disjoint_union
    def disjoint_union
      set_operation(:disjoint_union)
    end

    private

    # Produces the SetOperand resulting from +operator+ applied to this
    # operand.
    def set_operation(operator)
      Operation::OperationSetOperand.new(model, self, operator)
    end
  end

  # A module that gathers the classes and modules used in operation constraints.
  module Operation #:nodoc:
    class OperationSetOperand < Gecode::Set::ShortCircuitEqualityOperand #:nodoc:
      def initialize(model, enum, operator)
        super model
        @enum = enum
        @operator = operator
      end

      def constrain_equal(set_operand, constrain_domain, propagation_options)
        operation = Gecode::Util::SET_OPERATION_TYPES[@operator]
        if constrain_domain
          if operation == Gecode::Raw::SOT_INTER
            set_operand.must_be.subset_of @enum.first.upper_bound
          else
            set_operand.must_be.subset_of @enum.upper_bound_range
          end
        end
        
        Gecode::Raw::rel(@model.active_space, operation, 
          @enum.to_set_enum.bind_array, set_operand.to_set_var.bind)
      end
    end
  end
end
