module Gecode::Set
  module SetOperand
    # Produces an IntOperand representing the size of the set.
    #
    # ==== Examples 
    #
    #   # The size of +set+.
    #   set.size
    def size
      Cardinality::SetSizeOperand.new(@model, self)
    end
  end

  # A module that gathers the classes and modules used in cardinality 
  # constraints.
  module Cardinality #:nodoc:
    # Describes a cardinality constraint specifically for ranges. This is just
    # a special case which is used instead of the more general composite 
    # constraint when the target cardinality is a range. 
    class CardinalityConstraint < Gecode::Constraint #:nodoc:
      def post
        var, range = @params.values_at(:lhs, :range)
        Gecode::Raw::cardinality(@model.active_space, var.to_set_var.bind, 
          range.first, range.last)
      end
    end
    
    class SetSizeOperand < Gecode::Int::ShortCircuitEqualityOperand #:nodoc:
      def initialize(model, set_op)
        super model
        @set = set_op
      end

      def constrain_equal(int_operand, constrain, propagation_options)
        set = @set.to_set_var
        if constrain
          int_operand.must_be.in set.lower_bound.size..set.upper_bound.size
        end
        
        Gecode::Raw::cardinality(@model.active_space, set.bind, 
          int_operand.to_int_var.bind)
      end

      alias_method :pre_cardinality_construct_receiver, :construct_receiver
      def construct_receiver(params)
        receiver = pre_cardinality_construct_receiver(params)
        set = @set
        receiver.instance_eval{ @set = set }
        class <<receiver 
          alias_method :in_without_short_circuit, :in
          def in(range, options = {})
            if range.kind_of?(Range) and !@params[:negate] and 
                !options.has_key?(:reify)
              @params.update(:lhs => @set, :range => range)
              @model.add_constraint CardinalityConstraint.new(@model, @params)
            else
              in_without_short_circuit(range, options)
            end
          end
        end
        return receiver
      end
    end
  end
end
