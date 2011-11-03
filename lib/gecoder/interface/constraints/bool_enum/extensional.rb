module Gecode::BoolEnum
  class BoolEnumConstraintReceiver
    # Constrains all the operands in this enumeration to be equal to
    # one of the specified tuples. Neither negation nor reification is
    # supported.
    #
    # ==== Examples 
    # 
    #   # Constrains the three boolean operands in +bools+ to either
    #   # be true, false, true, or false, false, true.
    #   bools.must_be.in [[true, false, true], [false, false, true]]
    #
    #   # The same as above, but preferring speed over low memory usage.
    #   bools.must_be.in([[true, false, true], [false, false, true]], 
    #     :kind => :speed)
    def in(tuples, options = {})
      if @params[:negate]
        raise Gecode::MissingConstraintError, 'A negated tuple constraint is ' +
          'not implemented.'
      end
      unless options[:reify].nil?
        raise ArgumentError, 'Reification is not supported by the tuple ' + 
          'constraint.'
      end
      
      util = Gecode::Util
      
      # Check that the tuples are correct.
      expected_size = @params[:lhs].size
      util::Extensional.perform_tuple_checks(tuples, expected_size) do |tuple|
        unless tuple.all?{ |x| x.kind_of?(TrueClass) or x.kind_of?(FalseClass) }
          raise TypeError, 'All tuples must contain booleans.'
        end
      end
      
      @params[:tuples] = tuples
      @model.add_constraint Extensional::TupleConstraint.new(@model, 
        @params.update(Gecode::Util.decode_options(options)))
    end

    # Constrains the sequence of operands in this enumeration to match
    # a specified regexp in the boolean domain. Neither negation nor
    # reification is supported.
    #
    # The regular expressions are specified as described in 
    # IntEnumConstraintReceiver#match but true and false can be
    # used instead of integers.
    #
    # ==== Examples 
    #
    #   # Constrains the two boolean operands in +bools+ to be false
    #   # and true respectively.
    #   bools.must.match [false, true]
    #
    #   # Constrains the boolean operands in +bools+ to be false,
    #   # except for three consecutive operands which should be true
    #   # followed by false followed by true.
    #   bools.must.match [repeat(false), true, false, true, repeat(false)]]
    #
    def match(regexp, options = {})
      if @params[:negate]
        raise Gecode::MissingConstraintError, 'A negated regexp constraint ' +
          'is not implemented.'
      end
      unless options[:reify].nil?
        raise ArgumentError, 'Reification is not supported by the regexp ' + 
          'constraint.'
      end

      @params[:regexp] = 
        Gecode::Util::Extensional.parse_regexp regexp
      @params.update Gecode::Util.decode_options(options)
      @model.add_constraint Extensional::RegexpConstraint.new(@model, @params)
    end
  end
  
  # A module that gathers the classes and modules used in extensional 
  # constraints.
  module Extensional #:nodoc:
    class TupleConstraint < Gecode::Constraint #:nodoc:
      def post
        # Bind lhs.
        lhs = @params[:lhs].to_bool_enum.bind_array

        # Create the tuple set.
        tuple_set = Gecode::Raw::TupleSet.new
        @params[:tuples].each do |tuple|
          tuple_set.add tuple.map{ |b| b ? 1 : 0 }
        end
        tuple_set.finalize

        # Post the constraint.
        Gecode::Raw::extensional(@model.active_space, lhs, tuple_set, 
          *propagation_options)
      end
    end

    class RegexpConstraint < Gecode::Constraint #:nodoc:
      def post
        lhs, regexp = @params.values_at(:lhs, :regexp)
        Gecode::Raw::extensional(@model.active_space, 
          lhs.to_bool_enum.bind_array, regexp, *propagation_options)
      end
    end
  end
end
