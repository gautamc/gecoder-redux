module Gecode::IntEnum
  class IntEnumConstraintReceiver
    # Constrains this enumeration to "channel" +int_enum+.  Channel
    # constraints are used to give access to multiple viewpoints when
    # modelling. 
    # 
    # The channel constraint can be thought of as constraining the arrays to 
    # be each other's inverses. I.e. if the i:th value in the first enumeration
    # is j, then the j:th value in the second enumeration is constrained to be 
    # i.
    # 
    # Neither reification nor negation is supported.
    # 
    # ==== Examples 
    # 
    # Lets say that we're modelling a sequence of numbers that must be distinct
    # and that we want access to the following two view simultaneously.
    # 
    # === First view
    # 
    # The sequence is modelled as an array of integer variables where the first 
    # variable holds the value of the first position in the sequence, the 
    # second the value of the second position and so on.
    # 
    #   # n variables with values from 0 to n-1.
    #   elements = int_var_array(n, 0...n)
    #   elements.must_be.distinct
    # 
    # That way +elements+ will contain the actual sequence when the problem has 
    # been solved.
    # 
    # === Second view
    # 
    # The sequence is modelled as the positions of each value in 0..(n-1) in 
    # the sequence. That way the first variable would hold the positions of 0 
    # in the sequence, the second variable would hold the positions of 1 in the 
    # sequence and so on.
    # 
    #   positions = int_var_array(n, 0...n)
    #   positions.must_be.distinct
    # 
    # === Connecting the views
    #   
    # In essence the relationship between the two arrays +elements+ and 
    # +positions+ is that
    # 
    #   elements.map{ |e| e.val }[i] == positions.map{ |p| p.val }.index(i)
    # 
    # for all i in 0..(n-1). This relationship is enforced by the channel 
    # constraint as follows. 
    # 
    #   elements.must.channel positions
    # 
    def channel(int_enum, options = {})
      if @params[:negate]
        raise Gecode::MissingConstraintError, 'A negated channel constraint ' + 
          'is not implemented.'
      end
      unless int_enum.respond_to? :to_int_enum
        raise TypeError, "Expected int enum, got #{int_enum.class}."
      end
      if options.has_key? :reify
        raise ArgumentError, 'The channel constraints does not support the ' +
          'reification option.'
      end
      
      @params.update(Gecode::Util.decode_options(options))
      @params.update(:rhs => int_enum)
      @model.add_constraint Channel::ChannelConstraint.new(@model, @params)
    end
    
    # Provides commutativity with SetEnumConstraintReceiver#channel .
    provide_commutativity(:channel){ |rhs, _| rhs.respond_to? :to_set_enum }
  end
  
  # A module that gathers the classes and modules used in channel constraints.
  module Channel #:nodoc:
    class ChannelConstraint < Gecode::Constraint #:nodoc:
      def post
        lhs, rhs = @params.values_at(:lhs, :rhs)
        Gecode::Raw::channel(@model.active_space, lhs.to_int_enum.bind_array,
          rhs.to_int_enum.bind_array, *propagation_options)
      end
    end
  end
end
