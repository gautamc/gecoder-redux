module Gecode::IntEnum
  module IntEnumOperand
    # Produces a new IntOperand representing the number of times
    # +int_operand_or_fixnum+ is present in this enumeration.
    #
    # ==== Examples 
    #
    #   # The number of times 17 occurs in +int_enum+.
    #   int_enum.count(17)
    #
    #   # The number of times +int_operand+ occurs in +int_enum+.
    #   int_enum.count(int_operand)
    def count(int_operand_or_fixnum)
      unless int_operand_or_fixnum.respond_to? :to_int_var or 
          int_operand_or_fixnum.kind_of?(Fixnum)
        raise TypeError, 'Expected integer operand of fixnum, got ' + 
          "#{int_operand_or_fixnum.class}."
      end
      Count::IntEnumCountOperand.new(@model, self, int_operand_or_fixnum)
    end
  end

  # A module that gathers the classes and modules used in count constraints.
  module Count #:nodoc:
    class IntEnumCountOperand < Gecode::Int::ShortCircuitRelationsOperand #:nodoc:
      def initialize(model, int_enum, element)
        super model
        @enum = int_enum
        @element = element
      end
      
      def relation_constraint(relation, int_operand_or_fix, params)
        unless params[:negate]
          relation_type = 
            Gecode::Util::RELATION_TYPES[relation]
        else
          relation_type = 
            Gecode::Util::NEGATED_RELATION_TYPES[relation]
        end
        
        params.update(:enum => @enum, :element => @element, 
          :rhs => int_operand_or_fix, :relation_type => relation_type)
        CountConstraint.new(@model, params)
      end
    end
    
    class CountConstraint < Gecode::ReifiableConstraint #:nodoc:
      def post
        enum, element, relation_type, rhs = 
          @params.values_at(:enum, :element, :relation_type, :rhs)
        
        # Bind variables if needed.
        unless element.kind_of? Fixnum
          element = element.to_int_var.bind
        end
        unless rhs.kind_of? Fixnum
          rhs = rhs.to_int_var.bind
        end
        
        # Post the constraint to gecode.
        Gecode::Raw::count(@model.active_space, enum.to_int_enum.bind_array, 
          element, relation_type, rhs, *propagation_options)
      end
    end
  end
end
