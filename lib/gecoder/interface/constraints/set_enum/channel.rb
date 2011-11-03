module Gecode::SetEnum
  class SetEnumConstraintReceiver
    # Constrains this set enum to channel +int_enum_operand+. The i:th set 
    # in the enumeration of set operands is constrained to include the value 
    # of the j:th integer operand. 
    #
    # Neither reification nor negation is supported.
    #
    # ==== Examples 
    # 
    #   # +set_enum+ is constrained to channel +int_enum+.
    #   int_enum.must.channel set_enum
    # 
    #   # This is another way of writing the above.
    #   set_enum.must.channel int_enum
    def channel(enum, options = {})
      unless enum.respond_to? :to_int_enum
        raise TypeError, "Expected integer enum, for #{enum.class}."
      end
      if @params[:negate]
        raise Gecode::MissingConstraintError, 'A negated channel constraint ' + 
          'is not implemented.'
      end
      if options.has_key? :reify
        raise ArgumentError, 'The channel constraints does not support the ' +
          'reification option.'
      end
      
      @params.update(Gecode::Set::Util.decode_options(options))
      @params.update(:rhs => enum)
      @model.add_constraint Channel::IntEnumChannelConstraint.new(@model, @params)
    end
  end
  
  # A module that gathers the classes and modules used in channel constraints.
  module Channel #:nodoc:
    class IntEnumChannelConstraint < Gecode::Constraint #:nodoc:
      def post
        lhs, rhs = @params.values_at(:lhs, :rhs)
        Gecode::Raw::channel(@model.active_space, rhs.to_int_enum.bind_array, 
          lhs.to_set_enum.bind_array)
      end
    end
  end
end
