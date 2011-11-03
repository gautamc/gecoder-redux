module Gecode
  # An error signaling that the constraint specified is missing (e.g. one tried
  # to negate a constraint, but no negated form is implemented).
  class MissingConstraintError < StandardError
  end
  
  # Describes an operand, something that a constraint can be placed
  # on. Constraints are placed by calling #must or #must_not (the
  # latter negates the constraint). This produces a
  # ConstraintReceiver, which defines methods that places constraints
  # on the operand.
  #
  # In general this produces something like the following.
  # 
  #   operand.must.constraint_method(params)
  #
  # See e.g. Gecode::Int::IntOperand for concrete examples.
  # 
  # Classes that mix in Operand must define the methods #model
  # and #construct_receiver. They should also define a method that converts
  # the operand into a variable of the operand's type (e.g. int var
  # operands should define a method #to_int_var that returns an
  # instance of Gecode::IntVar that represents the operand). The
  # latter method should be used by constraints to fetch variables
  # needed when posting constraints. The presence of the method should
  # also be used for type checking (rather than e.g. checking whether
  # a parameter is of type IntOperand). 
  module Operand 
    # Specifies that a constraint must hold for the left hand side.
    def must
      construct_receiver :lhs => self, :negate => false
    end
    alias_method :must_be, :must
    
    # Specifies that the negation of a constraint must hold for the left hand 
    # side.
    def must_not
      construct_receiver :lhs => self, :negate => true
    end
    alias_method :must_not_be, :must_not

    # Fetches the model that the operand belongs to.
    def model
      raise NotImplementedError, 'Abstract method has not been implemented.'
    end
    
    private

    # Constructs the appropriate constraint receiver given the
    # specified parameters.
    def construct_receiver(params)
      raise NotImplementedError, 'Abstract method has not been implemented.'
    end
  end
  
  # Describes a constraint receiver, something that receives and 
  # places constraints on various Operand. Constraint receivers 
  # are created by calling #must or #must_not (the latter negates 
  # the constraint) on something that mixes in Operand.
  #
  # A constraint is placed on an Operand +operand+ as follows:
  #
  #   operand.must.constraint_method(params)
  #
  # The constraint receiver is created by the call to #must and the
  # constraint is then placed by the call to #constraint_method. 
  # See e.g. Gecode::Int::IntConstraintReceiver for 
  # concrete examples.
  #
  # The following options can be specified in a hash with symbols as
  # keys when placing a constraint:
  #
  # [:strength] The propagation strength suggests how much effort the 
  #             solver should put into trying to prune the domains of 
  #             variables using the constraint. 
  #
  #             The allowed values are:
  #             [:value] Value consistency (naive).
  #             [:bounds] Bounds consistency. The bounds of the operand 
  #                       will always be constrained as much as possible 
  #                       (but pruning may not be done inside the
  #                       bounds, even though it may be possible).
  #             [:domain] Domain consistency. All values that can be pruned 
  #                       away, given the current amount of information,
  #                       are pruned away.
  #             [:default] Uses the default consistency of the constraint.
  #             
  #             The strength generally progresses as 
  #             :value < :bounds < :domain (:value being the weakest, 
  #             :domain being the strongest). A higher strength can 
  #             reduce the search space quicker, but at the cost of 
  #             making each propagation more costly.
  #
  # [:kind]     The propagation kind option suggests the implementation
  #             that should be preferred if there are multiple 
  #             implementations of a constraint. 
  #
  #             The different kinds are:
  #             [:speed] Prefer speed over memory consumption.
  #             [:memory] Prefer low memory consumption over speed.
  #             [:default] Uses the constraint's default propagation kind.
  #
  # [:reify]    Reification is used to link a constraint to a boolean 
  #             operand in such a way that the variable is true if and
  #             only if the constraint is satisfied. The propagation
  #             goes both ways, so if the variable is constrained to be
  #             false then the constraint is not allowed to be
  #             satisfied.
  #
  #             Reification can be thought of as a last resort glue which 
  #             can be used to combine constraints so that e.g. exactly
  #             3 out of 17 constraints must be satisfied.
  #
  # Not all constraints accept all options. Constraints that have sets
  # as operands (e.g. SetConstraintReceiver and
  # SetEnumConstraintReceiver) do not accept the :strength and :kind
  # options, all other do. Some constraints do not accept the :reify
  # option.
  #
  # See e.g. Gecode::Int::IntConstraintReceiver for 
  # concrete examples of options being specified.
  class ConstraintReceiver
    # A list that keeps track of all constraint methods used in the
    # program, essentially providing unique ids for each.
    @@constraint_names_list ||= []

    # Constructs a new expression with the specified parameters. The 
    # parameters should at least contain the keys :lhs, and :negate.
    #
    # Raises ArgumentError if any of those keys are missing or if :lhs
    # is not an operand.
    def initialize(model, params)
      unless params.has_key?(:lhs) and params.has_key?(:negate)
        raise ArgumentError, 'Expression requires at least :lhs, ' + 
          "and :negate as parameter keys, got #{params.keys.join(', ')}."
      end
      unless params[:lhs].kind_of? Operand
        raise ArgumentError, 'Expected :lhs to be an operand, received ' + 
          "#{params[:lhs].class}."
      end
      
      @model = model
      @params = params
    end

    private

    # Provides commutativity for the constraint with the specified
    # method name. If the method with the specified method name is
    # called with something that, when given to the block, evaluates
    # to true, then the constraint will be called on the right hand
    # side with the left hand side as argument.
    #
    # The original constraint method is assumed to take two arguments:
    # a right hand side and a hash of options.
    def self.provide_commutativity(constraint_name, &block)
      unless @@constraint_names_list.include? constraint_name
        @@constraint_names_list << constraint_name 
      end
      unique_id = @@constraint_names_list.index(constraint_name)

      pre_alias_method_name = "pre_commutivity_#{unique_id}"
      if method_defined? constraint_name
        alias_method pre_alias_method_name, constraint_name
      end
      
      module_eval <<-end_code
        @@commutivity_check_#{unique_id} = block
        def #{constraint_name}(rhs, options = {})
          if @@commutivity_check_#{unique_id}.call(rhs, options)
            if @params[:negate]
              rhs.must_not.method(:#{constraint_name}).call(
                @params[:lhs], options)
            else
              rhs.must.method(:#{constraint_name}).call(
                @params[:lhs], options)
            end
          else
            if self.class.method_defined? :#{pre_alias_method_name}
              #{pre_alias_method_name}(rhs, options)
            else
              raise TypeError, \"Unexpected argument type \#{rhs.class}.\" 
            end
          end
        end
      end_code
    end
    
    # Creates aliases for any defined comparison methods.
    def self.alias_comparison_methods
      Gecode::Util::COMPARISON_ALIASES.each_pair do |orig, aliases|
        if instance_methods.include?(orig.to_s)
          aliases.each do |name|
            alias_method(name, orig)
          end
        end
      end
    end
    
    # Creates aliases for any defined set methods.
    def self.alias_set_methods
      Gecode::Util::SET_ALIASES.each_pair do |orig, aliases|
        if instance_methods.include?(orig.to_s)
          aliases.each do |name|
            alias_method(name, orig)
          end
        end
      end
    end
  end
  
  # Base class for all constraints.
  class Constraint #:nodoc:
    # Creates a constraint with the specified parameters, bound to the 
    # specified model. 
    def initialize(model, params)
      @model = model
      @params = params.clone
    end
    
    # Posts the constraint, adding it to the model. This is an abstract 
    # method and should be overridden by all sub-classes.
    def post
      raise NotImplementedError, 'Abstract method has not been implemented.'
    end
    
    private
    
    # Gives an array of the values selected for the standard propagation 
    # options (propagation strength and propagation kind) in the order that
    # they are given when posting constraints to Gecode.
    def propagation_options
      Gecode::Util::extract_propagation_options(@params)
    end
  end

  # A constraint that can be specified by providing a block containing the
  # post method.
  class BlockConstraint < Constraint #:nodoc:
    def initialize(model, params, &block)
      super(model, params)
      @proc = block
    end

    def post
      @proc.call
    end
  end

  # A module that provides some utility-methods for constraints.
  module Util #:nodoc:
    # Maps the name used in options to the value used in Gecode for 
    # propagation strengths.
    PROPAGATION_STRENGTHS = {
      :default  => Gecode::Raw::ICL_DEF,
      :value    => Gecode::Raw::ICL_VAL,
      :bounds   => Gecode::Raw::ICL_BND,
      :domain   => Gecode::Raw::ICL_DOM
    }
    
    # Maps the name used in options to the value used in Gecode for 
    # propagation kinds.
    PROPAGATION_KINDS = {
      :default  => Gecode::Raw::PK_DEF,
      :speed    => Gecode::Raw::PK_SPEED,
      :memory   => Gecode::Raw::PK_MEMORY,
    } 
    
    # Maps the names of the methods to the corresponding integer relation 
    # type in Gecode.
    RELATION_TYPES = { 
      :== => Gecode::Raw::IRT_EQ,
      :<= => Gecode::Raw::IRT_LQ,
      :<  => Gecode::Raw::IRT_LE,
      :>= => Gecode::Raw::IRT_GQ,
      :>  => Gecode::Raw::IRT_GR
    }
    # The same as above, but negated.
    NEGATED_RELATION_TYPES = {
      :== => Gecode::Raw::IRT_NQ,
      :<= => Gecode::Raw::IRT_GR,
      :<  => Gecode::Raw::IRT_GQ,
      :>= => Gecode::Raw::IRT_LE,
      :>  => Gecode::Raw::IRT_LQ
    }

    # Maps the names of the methods to the corresponding set relation type in 
    # Gecode.
    SET_RELATION_TYPES = { 
      :==         => Gecode::Raw::SRT_EQ,
      :superset   => Gecode::Raw::SRT_SUP,
      :subset     => Gecode::Raw::SRT_SUB,
      :disjoint   => Gecode::Raw::SRT_DISJ,
      :complement => Gecode::Raw::SRT_CMPL
    }
    # The same as above, but negated.
    NEGATED_SET_RELATION_TYPES = {
      :== => Gecode::Raw::SRT_NQ
    }
    # Maps the names of the methods to the corresponding set operation type in 
    # Gecode.
    SET_OPERATION_TYPES = { 
      :union          => Gecode::Raw::SOT_UNION,
      :disjoint_union => Gecode::Raw::SOT_DUNION,
      :intersection   => Gecode::Raw::SOT_INTER,
      :minus          => Gecode::Raw::SOT_MINUS
    }
    
    # Various method aliases for comparison methods. Maps the original 
    # (symbol) name to an array of aliases.
    COMPARISON_ALIASES = { 
      :== => [:equal, :equal_to],
      :>  => [:greater, :greater_than],
      :>= => [:greater_or_equal, :greater_than_or_equal_to],
      :<  => [:less, :less_than],
      :<= => [:less_or_equal, :less_than_or_equal_to]
    }
    SET_ALIASES = { 
      :==         => [:equal, :equal_to],
      :superset   => [:superset_of],
      :subset     => [:subset_of],
      :disjoint   => [:disjoint_with],
      :complement => [:complement_of]
    }
    
    module_function
    
    # Decodes the common options to constraints: strength, kind and 
    # reification. Returns a hash with up to three values. :strength is the 
    # strength that should be used for the constraint, :kind is the 
    # propagation kind that should be used, and :reif is the (bound) boolean 
    # operand that should be used for reification. The decoded options are 
    # removed from the hash (so in general the hash will be consumed in the 
    # process).
    # 
    # Raises ArgumentError if an unrecognized option is found in the specified
    # hash. Or if an unrecognized strength is given. Raises TypeError if the
    # reification operand is not a boolean operand.
    def decode_options(options)
      # Propagation strength.
      strength = options.delete(:strength) || :default
      unless PROPAGATION_STRENGTHS.include? strength
        raise ArgumentError, "Unrecognized propagation strength #{strength}."
      end
      
      # Propagation kind.
      kind = options.delete(:kind) || :default
      unless PROPAGATION_KINDS.include? kind
        raise ArgumentError, "Unrecognized propagation kind #{kind}."
      end  
                    
      # Reification.
      reif_var = options.delete(:reify)
      unless reif_var.nil? or reif_var.respond_to? :to_bool_var
        raise TypeError, 'Only boolean operands may be used for reification.'
      end
      
      # Check for unrecognized options.
      unless options.empty?
        raise ArgumentError, 'Unrecognized constraint option: ' + 
          options.keys.first.to_s
      end
      return {
        :strength => PROPAGATION_STRENGTHS[strength], 
        :kind => PROPAGATION_KINDS[kind],
        :reif => reif_var
      }
    end
    
    # Converts the different ways to specify constant sets in the interface
    # to the form that the set should be represented in Gecode (possibly 
    # multiple paramters. The different forms accepted are:
    # * Single instance of Fixnum (singleton set).
    # * Range (set containing all numbers in range), treated differently from
    #   other enumerations.
    # * Enumeration of integers (set contaning all numbers in set).
    def constant_set_to_params(constant_set)
      unless constant_set?(constant_set)
        raise TypeError, "Expected a constant set, got: #{constant_set}."
      end
    
      if constant_set.kind_of? Range
        return constant_set.first, constant_set.last
      elsif constant_set.kind_of? Fixnum
        return constant_set
      else
        constant_set = constant_set.to_a
        return Gecode::Raw::IntSet.new(constant_set, constant_set.size)
      end
    end
    
    # Converts the different ways to specify constant sets in the interface
    # to an instance of Gecode::Raw::IntSet. The different forms accepted are:
    # * Single instance of Fixnum (singleton set).
    # * Range (set containing all numbers in range), treated differently from
    #   other enumerations.
    # * Enumeration of integers (set contaning all numbers in set).
    def constant_set_to_int_set(constant_set)
      unless constant_set?(constant_set)
        raise TypeError, "Expected a constant set, got: #{constant_set}."
      end
      
      if constant_set.kind_of? Range
        return Gecode::Raw::IntSet.new(constant_set.first, constant_set.last)
      elsif constant_set.kind_of? Fixnum
        return Gecode::Raw::IntSet.new([constant_set], 1)
      else
        constant_set = constant_set.to_a
        return Gecode::Raw::IntSet.new(constant_set, constant_set.size)
      end
    end
    
    # Checks whether the specified expression is regarded as a constant set.
    # Returns true if it is, false otherwise.
    def constant_set?(expression)
      return (
         expression.kind_of?(Range) &&        # It's a range.
         expression.first.kind_of?(Fixnum) &&
         expression.last.kind_of?(Fixnum)) ||
        expression.kind_of?(Fixnum) ||        # It's a single fixnum.
        (expression.kind_of?(Enumerable) &&   # It's an enum of fixnums.
         expression.all?{ |e| e.kind_of? Fixnum })
    end
    
    # Extracts an array of the values selected for the standard propagation 
    # options (propagation strength and propagation kind) from the hash of
    # parameters given. The options are returned in the order that they are 
    # given when posting constraints to Gecode.      
    def extract_propagation_options(params)
      params.values_at(:strength, :kind)
    end
  end
  
  # A module that contains utility-methods for extensional constraints.
  module Util::Extensional #:nodoc:
    module_function
    
    # Checks that the specified enumeration is an enumeration containing 
    # one or more tuples of the specified size. It also allows the caller
    # to define additional tests by providing a block, which is given each
    # tuple. If a test fails then an appropriate error is raised.
    def perform_tuple_checks(tuples, expected_size, &additional_test)
      unless tuples.respond_to?(:each)
        raise TypeError, 'Expected an enumeration with tuples, got ' + 
          "#{tuples.class}."
      end
      
      if tuples.empty?
        raise ArgumentError, 'One or more tuples must be specified.'
      end
      
      tuples.each do |tuple|
        unless tuple.respond_to?(:each)
          raise TypeError, 'Expected an enumeration containing enumeraions, ' +
            "got #{tuple.class}."
        end
        
        unless tuple.size == expected_size
          raise ArgumentError, 'All tuples must be of the same size as the ' + 
            'number of operands in the array.'
        end
        
        yield tuple
      end
    end
  end
end

require 'gecoder/interface/constraints/reifiable_constraints'
require 'gecoder/interface/constraints/int_var_constraints'
require 'gecoder/interface/constraints/int_enum_constraints'
require 'gecoder/interface/constraints/bool_var_constraints'
require 'gecoder/interface/constraints/bool_enum_constraints'
require 'gecoder/interface/constraints/set_var_constraints'
require 'gecoder/interface/constraints/set_enum_constraints'
require 'gecoder/interface/constraints/selected_set_constraints'
require 'gecoder/interface/constraints/set_elements_constraints'
require 'gecoder/interface/constraints/fixnum_enum_constraints'
require 'gecoder/interface/constraints/extensional_regexp'
