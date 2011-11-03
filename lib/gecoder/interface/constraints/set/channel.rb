module Gecode::Set
  class SetConstraintReceiver
    # Constrains this set to channel +bool_enum+. The set is constrained
    # to include value i exactly when the operand at index i in the
    # boolean enumeration is true.
    # 
    # Neither reification nor negation is supported. The boolean enum and set
    # can be interchanged.
    #
    # ==== Examples 
    #
    #   # Constrains the enumeration of boolean operands called +bools+ to at
    #   # least have the first and third operands set to true 
    #   set.must_be.superset_of [0, 2]
    #   set.must.channel bools
    #
    #   # An alternative way of writing the above.
    #   set.must_be.superset_of [0, 2]
    #   bools.must.channel set
    def channel(bool_enum, options = {})
      if @params[:negate]
        raise Gecode::MissingConstraintError, 'A negated channel constraint ' + 
          'is not implemented.'
      end
      if options.has_key? :reify
        raise ArgumentError, 'The channel constraint does not support the ' + 
          'reification option.'
      end
      unless bool_enum.respond_to? :to_bool_enum
        raise TypeError, 'Expected an enum of bool operands, ' + 
          "got #{bool_enum.class}."
      end
      
      @params.update(:rhs => bool_enum)
      @params.update Gecode::Set::Util.decode_options(options)
      @model.add_constraint Channel::ChannelConstraint.new(@model, @params)
    end
  end
  
  # A module that gathers the classes and modules used in channel constraints
  # involving one set operand and a boolean enum.
  module Channel #:nodoc:
    class ChannelConstraint < Gecode::Constraint #:nodoc:
      def post
        lhs, rhs = @params.values_at(:lhs, :rhs)
        Gecode::Raw::channel(@model.active_space, rhs.to_bool_enum.bind_array, 
          lhs.to_set_var.bind)
      end
    end
  end
end
