module Gecode::FixnumEnum
  module FixnumEnumOperand
    # Produces a new SetOperand representing the union between this operand, 
    # interpreted as a constant set, and +set_operand+.
    #
    # ==== Examples 
    #
    #   # The union between +fixnum_enum+ and +set+.
    #   fixnum_enum.union set
    def union(set_operand)
      set_operation(:union, set_operand)
    end

    # Produces a new SetOperand representing the disjoint union between
    # this operand, interpreted as a constant set, and
    # +set_operand+. The disjoint union is the union of
    # the disjoint parts of the sets.
    #
    # ==== Examples 
    #
    #   # The disjoint union between +fixnum_enum+ and +set+.
    #   fixnum_enum.disjoint_union set
    def disjoint_union(set_operand)
      set_operation(:disjoint_union, set_operand)
    end

    # Produces a new SetOperand representing the intersection between
    # this operand, interpreted as a constant set, and
    # +set_operand+. 
    #
    # ==== Examples 
    #
    #   # The intersection between +fixnum_enum+ and +set+.
    #   fixnum_enum.intersection set
    def intersection(set_operand)
      set_operation(:intersection, set_operand)
    end

    # Produces a new SetOperand representing this operand, interpreted
    # as a constant set, minus +set_operand+. 
    #
    # ==== Examples 
    #
    #   # +fixnum_enum+ minus +set+.
    #   fixnum_enum.minus set
    def minus(set_operand)
      set_operation(:minus, set_operand)
    end

    private 

    # Starts a constraint on this set #{name} the specified set.
    def set_operation(operator, operand2)
      unless operand2.respond_to? :to_set_var
        raise TypeError, 'Expected set operand as ' + 
          "operand, got \#{operand2.class}."
      end

      return Operation::OperationSetOperand.new(model, self, 
        operator, operand2)
    end
  end

  Operation = Gecode::Set::Operation
end
