module Gecode::BoolEnum
  class BoolEnumConstraintReceiver
    # Constrains this enumeration to "channel" +integer_operand+. This 
    # constrains the integer operand to take value i exactly when the 
    # operand at index i in the boolean enumeration is true and the others 
    # are false.
    # 
    # Beyond the common options the channel constraint can
    # also take the following option:
    #
    # [:offset]  Specifies an offset for the integer operand. If the offset is
    #            set to k then the integer operand takes value i+k exactly 
    #            when the operand at index i in the boolean enumeration is 
    #            true and the rest are false.
    # 
    # Neither reification nor negation is supported. The int operand
    # and the enumeration can be interchanged.
    #
    # ==== Examples 
    #
    #   # Constrains the enumeration called +option_is_selected+ to be false 
    #   # in the first four positions and have exactly one true operand in 
    #   # the other. 
    #   option_is_selected.must.channel selected_option_index 
    #   selected_option_index.must_be > 3
    #
    #   # Constrains the enumeration called +option_is_selected+ to be false 
    #   # in the first five positions and have exactly one true operand in 
    #   # the other. 
    #   selected_option_index.must.channel(option_is_selected, :offset => 1) 
    #   selected_option_index.must_be > 3
    def channel(integer_operand, options = {})
      if @params[:negate]
        raise Gecode::MissingConstraintError, 'A negated channel constraint ' + 
          'is not implemented.'
      end
      if options.has_key? :reify
        raise ArgumentError, 'The channel constraint does not support the ' + 
          'reification option.'
      end
      unless integer_operand.respond_to? :to_int_var
        raise TypeError, 'Expected an integer operand, got ' + 
          "#{integer_operand.class}."
      end
      
      @params.update(:rhs => integer_operand, 
        :offset => options.delete(:offset) || 0)
      @params.update(Gecode::Util.decode_options(options))
      @model.add_constraint Channel::ChannelConstraint.new(@model, @params)
    end

    # Provides commutativity with SetConstraintReceiver#channel
    provide_commutativity(:channel){ |rhs, _| rhs.respond_to? :to_set_var }
  end
  
  # A module that gathers the classes and modules used in channel constraints
  # involving one boolean enum and one integer operand.
  module Channel #:nodoc:
    class ChannelConstraint < Gecode::Constraint #:nodoc:
      def post
        lhs, rhs, offset = @params.values_at(:lhs, :rhs, :offset)
        Gecode::Raw::channel(@model.active_space, 
          lhs.to_bool_enum.bind_array, rhs.to_int_var.bind, 
          offset, *propagation_options)
      end
    end
  end
end
