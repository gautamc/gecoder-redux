module Gecode
  module Mixin
    # Specifies which variables that should be branched on (given as an
    # enum of operands or as a single operand). One can optionally
    # also select which of the variables that should be used first with
    # the :variable option and which value in that variable's domain
    # that should be used with the :value option. If nothing is
    # specified then :variable uses :none and value uses :min.
    #
    # The following values can be used with :variable for integer and
    # boolean enums:
    # [:none]                 The first unassigned variable.
    # [:smallest_min]         The one with the smallest minimum.
    # [:largest_min]          The one with the largest minimum.
    # [:smallest_max]         The one with the smallest maximum.
    # [:largest_max]          The one with the largest maximum.
    # [:smallest_size]        The one with the smallest size.
    # [:largest_size]         The one with the larges size.
    # [:smallest_degree]      The one with the smallest degree. The degree of a 
    #                         variable is defined as the number of dependant 
    #                         propagators. In case of ties, choose the variable 
    #                         with smallest domain.
    # [:largest_degree]       The one with the largest degree. The degree of a 
    #                         variable is defined as the number of dependant 
    #                         propagators. In case of ties, choose the variable 
    #                         with smallest domain.
    # [:smallest_min_regret]  The one with the smallest min-regret. The 
    #                         min-regret of a variable is the difference between
    #                         the smallest and second-smallest value still in 
    #                         the domain.
    # [:largest_min_regret]   The one with the largest min-regret. The 
    #                         min-regret of a variable is the difference between
    #                         the smallest and second-smallest value still in 
    #                         the domain.
    # [:smallest_max_regret]  The one with the smallest max-regret The 
    #                         max-regret of a variable is the difference between
    #                         the largest and second-largest value still in 
    #                         the domain.
    # [:largest_max_regret]   The one with the largest max-regret. The 
    #                         max-regret of a variable is the difference between
    #                         the largest and second-largest value still in 
    #                         the domain.
    #
    # The following values can be used with :value for integer and boolean 
    # enums:
    # [:min]        Selects the smallest value.
    # [:med]        Select the median value.
    # [:max]        Selects the largest vale
    # [:split_min]  Selects the lower half of the domain.
    # [:split_max]  Selects the upper half of the domain.
    #
    # The following values can be used with :variable for set enums:
    # [:none]                 The first unassigned set.
    # [:smallest_cardinality] The one with the smallest cardinality.
    # [:largest_cardinality]  The one with the largest cardinality.
    # [:smallest_unknown]     The one with the smallest number of unknown 
    #                         elements 
    # [:largest_unknown]      The one with the largest number of unknown 
    #                         elements
    #
    # The following values can be used with :value set enums: 
    # [:min]        Selects the smallest value in the unknown part of the set.
    # [:max]        Selects the largest value in the unknown part of the set.
    def branch_on(variables, options = {})
      if variables.respond_to?(:to_int_var) or 
          variables.respond_to?(:to_bool_var) or 
          variables.respond_to?(:to_set_var)
        variables = wrap_enum [variables]
      end

      if variables.respond_to? :to_int_enum 
        add_branch(variables.to_int_enum, options,
          Constants::BRANCH_INT_VAR_CONSTANTS, 
          Constants::BRANCH_INT_VALUE_CONSTANTS)
      elsif variables.respond_to? :to_bool_enum
        add_branch(variables.to_bool_enum, options, 
          Constants::BRANCH_INT_VAR_CONSTANTS, 
          Constants::BRANCH_INT_VALUE_CONSTANTS)
      elsif variables.respond_to? :to_set_enum
        add_branch(variables.to_set_enum, options, 
          Constants::BRANCH_SET_VAR_CONSTANTS, 
          Constants::BRANCH_SET_VALUE_CONSTANTS)
      else
        raise TypeError, "Unknown type of variable enum #{variables.class}."
      end
    end
    
    private
    
    # This is a hack to get RDoc to ignore the constants.
    module Constants #:nodoc:
      # Maps the names of the supported variable branch strategies for
      # integer and booleans to the corresponding constant in Gecode. 
      BRANCH_INT_VAR_CONSTANTS = {
        :none                 => Gecode::Raw::INT_VAR_NONE,
        :smallest_min         => Gecode::Raw::INT_VAR_MIN_MIN,
        :largest_min          => Gecode::Raw::INT_VAR_MIN_MAX, 
        :smallest_max         => Gecode::Raw::INT_VAR_MAX_MIN, 
        :largest_max          => Gecode::Raw::INT_VAR_MAX_MAX, 
        :smallest_size        => Gecode::Raw::INT_VAR_SIZE_MIN, 
        :largest_size         => Gecode::Raw::INT_VAR_SIZE_MAX,
        :smallest_degree      => Gecode::Raw::INT_VAR_DEGREE_MIN, 
        :largest_degree       => Gecode::Raw::INT_VAR_DEGREE_MAX, 
        :smallest_min_regret  => Gecode::Raw::INT_VAR_REGRET_MIN_MIN,
        :largest_min_regret   => Gecode::Raw::INT_VAR_REGRET_MIN_MAX,
        :smallest_max_regret  => Gecode::Raw::INT_VAR_REGRET_MAX_MIN, 
        :largest_max_regret   => Gecode::Raw::INT_VAR_REGRET_MAX_MAX
      }
      # Maps the names of the supported variable branch strategies for sets to 
      # the corresponding constant in Gecode. 
      BRANCH_SET_VAR_CONSTANTS = { #:nodoc:
        :none                 => Gecode::Raw::SET_VAR_NONE,
        :smallest_cardinality => Gecode::Raw::SET_VAR_MIN_CARD,
        :largest_cardinality  => Gecode::Raw::SET_VAR_MAX_CARD, 
        :smallest_unknown     => Gecode::Raw::SET_VAR_MIN_UNKNOWN_ELEM, 
        :largest_unknown      => Gecode::Raw::SET_VAR_MAX_UNKNOWN_ELEM
      }
      
      # Maps the names of the supported value branch strategies for integers and
      # booleans to the corresponding constant in Gecode. 
      BRANCH_INT_VALUE_CONSTANTS = { #:nodoc:
        :min        => Gecode::Raw::INT_VAL_MIN,
        :med        => Gecode::Raw::INT_VAL_MED,
        :max        => Gecode::Raw::INT_VAL_MAX,
        :split_min  => Gecode::Raw::INT_VAL_SPLIT_MIN,
        :split_max  => Gecode::Raw::INT_VAL_SPLIT_MAX
      }
      # Maps the names of the supported value branch strategies for sets to the 
      # corresponding constant in Gecode. 
      BRANCH_SET_VALUE_CONSTANTS = { #:nodoc:
        :min  => Gecode::Raw::SET_VAL_MIN,
        :max  => Gecode::Raw::SET_VAL_MAX
      }
    end
    
    # Adds a branching selection for the specified variables with the specified
    # options. The hashes are used to decode the options into Gecode's 
    # constants.
    def add_branch(variables, options, branch_var_hash, branch_value_hash)
      # Extract optional arguments.
      var_strat = options.delete(:variable) || :none
      val_strat = options.delete(:value) || :min
    
      # Check that the options are correct.
      unless options.empty?
        raise ArgumentError, 'Unknown branching option given: ' + 
          options.keys.join(', ')
      end
      unless branch_var_hash.include? var_strat
        raise ArgumentError, "Unknown variable selection strategy: #{var_strat}"
      end
      unless branch_value_hash.include? val_strat
        raise ArgumentError, "Unknown value selection strategy: #{val_strat}"
      end

      # Add the branching as a gecode interaction.
      add_interaction do
        Gecode::Raw.branch(active_space, variables.bind_array, 
          branch_var_hash[var_strat], branch_value_hash[val_strat])
      end
    end
  end
end
