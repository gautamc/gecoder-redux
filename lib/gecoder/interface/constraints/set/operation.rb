module Gecode::Set
  module SetOperand
    # Produces a new SetOperand representing the union between this operand 
    # and +set_operand_or_constant_set+.
    #
    # ==== Examples 
    #
    #   # The union between +set1+ and +set2+.
    #   set1.union set2
    #
    #   # The union between +set+ and {1, 3, 5}.
    #   set.union [1,3,5]
    def union(set_operand_or_constant_set)
      set_operation(:union, set_operand_or_constant_set)
    end

    # Produces a new SetOperand representing the disjoint union between
    # this operand and +set_operand_or_constant_set+. The disjoint union
    # is the union of the disjoint parts of the sets.
    #
    # ==== Examples 
    #
    #   # The disjoint union between +set1+ and +set2+.
    #   set1.disjoint_union set2
    #
    #   # The disjoint union between +set+ and {1, 3, 5}.
    #   set.disjoint_union [1,3,5]
    def disjoint_union(set_operand_or_constant_set)
      set_operation(:disjoint_union, set_operand_or_constant_set)
    end

    # Produces a new SetOperand representing the intersection between
    # this operand and +set_operand_or_constant_set+. 
    #
    # ==== Examples 
    #
    #   # The intersection between +set1+ and +set2+.
    #   set1.intersection set2
    #
    #   # The intersection between +set+ and {1, 3, 5}.
    #   set.intersection [1,3,5]
    def intersection(set_operand_or_constant_set)
      set_operation(:intersection, set_operand_or_constant_set)
    end

    # Produces a new SetOperand representing this operand minus 
    # +set_operand_or_constant_set+. 
    #
    # ==== Examples 
    #
    #   # +set1+ minus +set2+.
    #   set1.minus set2
    #
    #   # +set+ minus {1, 3, 5}.
    #   set.minus [1,3,5]
    def minus(set_operand_or_constant_set)
      set_operation(:minus, set_operand_or_constant_set)
    end

    private 

    # Produces the SetOperand resulting from +operator+ applied to this
    # operand and +operand2+.
    def set_operation(operator, operand2)
      unless operand2.respond_to? :to_set_var or 
        Gecode::Util::constant_set?(operand2)
        raise TypeError, 'Expected set operand or constant set as ' + 
              "operand, got \#{operand2.class}."
      end

      return Operation::OperationSetOperand.new(model, self, operator, 
        operand2)
    end
  end

  # A module that gathers the classes and modules used in operation constraints.
  module Operation #:nodoc:
    class OperationSetOperand < Gecode::Set::ShortCircuitRelationsOperand #:nodoc:
      def initialize(model, op1, operator, op2)
        super model
        @op1 = op1
        @op2 = op2
        @operator = operator
      end

      def relation_constraint(relation, set_operand_or_constant_set, params)
        relation_type = 
          Gecode::Util::SET_RELATION_TYPES[relation]

        operation = Gecode::Util::SET_OPERATION_TYPES[@operator]
        params.update(:rhs => set_operand_or_constant_set, 
          :relation_type => relation_type, :op1 => @op1, :op2 => @op2,
          :operation => operation)
        OperationConstraint.new(model, params)
      end
    end
    
    class OperationConstraint < Gecode::Constraint #:nodoc:
      def post
        op1, op2, operation, relation, rhs, negate = @params.values_at(:op1, 
          :op2, :operation, :relation_type, :rhs, :negate)

        op1, op2, rhs = [op1, op2, rhs].map do |expression|
          # The expressions can either be set operands or constant sets, 
          # convert them appropriately.
          if expression.respond_to? :to_set_var
            expression.to_set_var.bind
          else
            Gecode::Util::constant_set_to_int_set(expression)
          end
        end

        Gecode::Raw::rel(@model.active_space, op1, operation, op2, 
          relation, rhs)
      end
    end
  end
end
