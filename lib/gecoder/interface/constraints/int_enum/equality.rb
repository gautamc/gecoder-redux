module Gecode::IntEnum
  class IntEnumConstraintReceiver
    # Constrains all operands in the enumeration to be equal. 
    # Neither negation nor reification is supported.
    # 
    # ==== Examples 
    # 
    #   # Constrains all operands in +int_enum+ to be equal.
    #   int_enum.must_be.equal
    def equal(options = {})
      if @params[:negate]
        # The best we could implement it as from here would be a bunch of 
        # reified pairwise inequality constraints.
        raise Gecode::MissingConstraintError, 'A negated equality is not ' + 
          'implemented.'
      end
      unless options[:reify].nil?
        raise ArgumentError, 'Reification is not supported by the equality ' + 
          'constraint.'
      end
    
      @model.add_constraint Equality::EqualityConstraint.new(@model, 
        @params.update(Gecode::Util.decode_options(options)))
    end
  end
  
  # A module that gathers the classes and modules used in equality constraints.
  module Equality #:nodoc:
    class EqualityConstraint < Gecode::Constraint #:nodoc:
      def post
        Gecode::Raw::rel(@model.active_space,
          @params[:lhs].to_int_enum.bind_array, 
          Gecode::Raw::IRT_EQ, *propagation_options)
      end
    end
  end
end
