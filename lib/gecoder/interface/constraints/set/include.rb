module Gecode::Set
  class SetConstraintReceiver
    # Constrains this set to include the values of +int_enum+.
    # 
    # The constraint has the side effect of sorting the integer operands in a 
    # non-descending order. It does not support reification nor negation.
    # 
    # ==== Examples 
    # 
    #   # Constrain +set+ to include the values of all operands in 
    #   # +int_enum+.
    #   set.must.include int_enum 
    def include(int_enum)
      unless int_enum.respond_to? :to_int_enum
        raise TypeError, "Expected int var enum, got #{int_enum.class}."
      end
      if @params[:negate]
        raise Gecode::MissingConstraintError, 'A negated include is not ' + 
          'implemented.'
      end
      
      @params.update(:variables => int_enum)
      @model.add_constraint Connection::IncludeConstraint.new(@model, @params)
    end
  end

  module Connection #:nodoc:
    class IncludeConstraint < Gecode::Constraint #:nodoc:
      def post
        set, variables = @params.values_at(:lhs, :variables)
        Gecode::Raw::match(@model.active_space, set.to_set_var.bind, 
                           variables.to_int_enum.bind_array)
      end
    end
  end
end
