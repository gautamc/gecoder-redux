module Gecode::IntEnum
  class IntEnumConstraintReceiver
    # Constrains all integer operands in the enumeration to be distinct
    # (different). The constraint can also be used with constant
    # offsets, so that the operands, with specified offsets added, must
    # be distinct.
    # 
    # The constraint does not support negation nor reification.
    # 
    # ==== Examples 
    # 
    #   # Constrains all operands in +int_enum+ to be assigned different 
    #   # values.
    #   int_enum.must_be.distinct
    #   
    #   # The same as above, but also selects that the strength +domain+ should
    #   # be used.
    #   int_enum.must_be.distinct(:strength => :domain)
    #   
    #   # Uses the offset to constrain that no number may be the previous number
    #   # incremented by one.
    #   numbers = int_var_array(8, 0..9)
    #   numbers.must_be.distinct(:offsets => (1..numbers.size).to_a.reverse)
    def distinct(options = {})
      if @params[:negate]
        # The best we could implement it as from here would be a bunch of 
        # reified pairwise equality constraints. 
        raise Gecode::MissingConstraintError, 'A negated distinct is not ' + 
          'implemented.'
      end
      unless options[:reify].nil?
        raise ArgumentError, 'Reification is not supported by the distinct ' + 
          'constraint.'
      end

      if options.has_key? :offsets
        offsets = options.delete(:offsets)
        unless offsets.kind_of? Enumerable
          raise TypeError, 'Expected Enumerable as offsets, got ' + 
            "#{offsets.class}."
        end
        @params[:offsets] = offsets
      end
      @model.add_constraint Distinct::DistinctConstraint.new(@model, 
        @params.update(Gecode::Util.decode_options(options)))
    end
  end
  
  # A module that gathers the classes and modules used in distinct constraints.
  module Distinct #:nodoc:
    class DistinctConstraint < Gecode::Constraint #:nodoc:
      def post
        # Bind lhs.
        @params[:lhs] = @params[:lhs].to_int_enum.bind_array
        
        # Fetch the parameters to Gecode.
        params = @params.values_at(:offsets, :lhs)
        params.delete_if{ |x| x.nil? }
        params.concat propagation_options
        Gecode::Raw::distinct(@model.active_space, *params)
      end
    end
  end
end
