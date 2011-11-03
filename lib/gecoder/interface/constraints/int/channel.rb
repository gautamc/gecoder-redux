module Gecode::Int
  class IntConstraintReceiver
    alias_method :pre_channel_equals, :==
    
    # Constrains the integer operand to be equal to the specified boolean 
    # operand. I.e. constrains the integer operand to be 1 when the boolean
    # operand is true and 0 if the boolean operand is false.
    #
    # ==== Examples 
    #
    #   # The integer operand +int+ must be one exactly when the boolean 
    #   # operand +bool+ is true.
    #   int.must == bool
    def ==(bool, options = {})
      unless @params[:lhs].respond_to? :to_int_var and 
          bool.respond_to? :to_bool_var
        return pre_channel_equals(bool, options)
      end
      
      if @params[:negate]
        raise Gecode::MissingConstraintError, 'A negated channel constraint ' +
          'is not implemented.'
      end
      unless options[:reify].nil?
        raise ArgumentError, 'Reification is not supported by the channel ' + 
          'constraint.'
      end
      
      @params.update(Gecode::Util.decode_options(options))
      @params[:rhs] = bool
      @model.add_constraint Channel::ChannelConstraint.new(@model, @params)
    end
    
    alias_comparison_methods
    
    # Provides commutativity with BoolEnumConstraintReceiver#channel .
    provide_commutativity(:channel){ |rhs, _| rhs.respond_to? :to_bool_enum }
  end
  
  # A module that gathers the classes and modules used in channel constraints
  # involving a single integer operand.
  module Channel #:nodoc:
    class ChannelConstraint < Gecode::Constraint #:nodoc:
      def post
        lhs, rhs = @params.values_at(:lhs, :rhs)
        Gecode::Raw::channel(@model.active_space, lhs.to_int_var.bind, 
          rhs.to_bool_var.bind, *propagation_options)
      end
    end
  end
end
