module Gecode::IntEnum
  class IntEnumConstraintReceiver
    # Constrains all the operands in this enumeration to be equal to
    # one of the specified tuples. Neither negation nor reification is
    # supported.
    # 
    # ==== Examples 
    # 
    #   # Constrains the two integer operands in +numbers+ to either have 
    #   # values 1 and 7, or values 47 and 11.
    #   numbers.must_be.in [[1,7], [47,11]]
    #
    #   # The same as above, but preferring speed over low memory usage.
    #   numbers.must_be.in([[1,7], [47,11]], :kind => :speed)
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
        unless tuple.all?{ |x| x.kind_of? Fixnum }
          raise TypeError, 'All tuples must contain Fixnum.'
        end
      end
    
      @params[:tuples] = tuples
      @model.add_constraint Extensional::TupleConstraint.new(@model, 
        @params.update(util.decode_options(options)))
    end

    # Constrains the sequence of operands in this enumeration to match
    # a specified regexp in the integer domain. Neither negation nor
    # reification is supported.
    #
    # == Regexp syntax
    #
    # The regular expressions are specified using arrays, integers and a
    # few methods provided by Mixin. Arrays are used to group the
    # integers in sequences that must be matched. The following array
    # describes a regular expression matching a 1 followed by a 7.
    #
    #   [1, 7]
    #
    # Arrays can be nested or left out when not needed. I.e. the above
    # is semantically equal to
    #
    #   [[[1], 7]]
    #
    # A couple of methods provided by Mixin are used to express patterns 
    # beyond mere sequences:
    #
    # [Mixin#repeat] Used for specifying patterns that include patterns
    #                that may be repeated a given number of times. The 
    #                number of times to repeat a pattern can be specified 
    #                using a lower and upper bound, but the bounds can be 
    #                omitted to for instance allow an expression to be 
    #                repeated any number of times.
    # [Mixin#any]    Used for specifying alternatives.
    # 
    # Additionally Mixin#at_least_once and Mixin#at_most_once are
    # provided as convenience methods.
    #
    # ==== Examples 
    #
    #   # Matches 1 followed by any number of 2s.
    #   [1, repeat(2)]
    #
    #   # Semantically the same as above. It just has a bunch of
    #   # needless brackets thrown in.
    #   [[1], [repeat([2])]]
    #
    #   # Matches 1 followed by [a 2 followed by a 3] at least two times.
    #   # Matches e.g. 1, 2, 3, 2, 3
    #   [1, repeat([2, 3], 2)]
    #
    #   # Matches between one and two [2 followed by [at least three 1]] 
    #   # followed by between three and four 3. Matches e.g. 
    #   # 2, 1, 1, 1, 2, 1, 1, 1, 3, 3, 3
    #   [repeat([2, repeat(1, 3], 1, 2), repeat(3, 3, 4)]
    #
    #   # Matches [1, 2 or 3] followed by 4. Matches e.g. 2, 4
    #   [any(1, 2, 3), 4]
    #
    #   # Matches 0 followed by [[1 followed by 2] or [3 followed by 5]]. 
    #   # Matches e.g. 0, 1, 2 as well as 0, 3, 5
    #   [0, any([1, 2], [3, 5])]
    #
    #   # Matches 0 followed by [[[1 followed by 7] at least two times] 
    #   # or [[8, 9], at most two times]. Matches e.g. 
    #   # 0, 1, 7, 1, 7, 1, 7 as well as 0, 8, 9
    #   [0, any(repeat([1, 7], 2), repeat([8, 9], 0, 2)]
    #
    #   # Matches 0 followed by at least one 1.
    #   [0, at_least_once(1)]
    #
    #   # Exactly the same as the above.
    #   [0, repeat(1, 1)]
    #
    #   # Matches 0 followed by at least one [[1 followed by 7] or [3
    #   # followed by 2]]. Matches e.g. 0, 1, 7, 3, 2, 1, 7
    #   [0, at_least_once(any([1, 7], [3, 2]]
    #
    #   # Matches 0 followed by at either [[1 followed by 7] at least once] 
    #   # or [[3 followed by 2] at least once]. Matches e.g. 
    #   # 0, 1, 7, 1, 7 but does _not_ match 0, 1, 7, 3, 2, 1, 7
    #   [0, any(at_least_once([1, 7]), at_least_once([3, 2])]
    #
    #   # Matches 0, followed by at most one 1. Matches 0 as well as 
    #   # 0, 1
    #   [0, at_most_once(1)]
    #
    #   # Exactly the same as the above.
    #   [0, repeat(1, 0, 1)]
    #
    # ==== Examples 
    #
    #   # Constrains the two integer operands in +numbers+ to have
    #   # values 1 and 7.
    #   numbers.must.match [1, 7]
    #
    #   # Constrains the integer operands in +numbers+ to contain the
    #   # value 47 followed by 11, with all other values set to -1.
    #   numbers.must.match [repeat(-1), 47, 11, repeat(-1)]
    #
    #   # Constrains exactly three of the integer operands in +numbers+ to 
    #   # contain 47 or 11, each followed by at least two
    #   # operands set to -1. All other operands are constrained to
    #   # equal -1.
    #   numbers.must.match repeat([repeat(-1), any(11, 47), 
    #                              repeat(-1, 2)], 3, 3)
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
        lhs = @params[:lhs].to_int_enum.bind_array

        # Create the tuple set.
        tuple_set = Gecode::Raw::TupleSet.new
        @params[:tuples].each do |tuple|
          tuple_set.add tuple
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
          lhs.to_int_enum.bind_array, regexp, *propagation_options)
      end
    end
  end
end
