module Gecode
  # Mixin contains the base functionality needed to formulate problems.
  #
  # == Formulating problems
  #
  # Problems are formulated by building a model that represents the
  # problem. A model is a class that mixes in Mixin and uses its
  # functionality to define variables and constraints that describe the
  # problem. Below is an example of a model that formulates the problem
  # of finding a solution to the following equation system.
  #
  # Equation system:
  #   x + y = z
  #   x = y - 3
  #   0 <= x,y,z <= 9
  #
  # Model:
  #   class EquationProblem 
  #     include Gecode::Mixin
  #
  #     attr :vars
  #
  #     def initialize
  #       x, y, z = @vars = int_var_array(3, 0..9)
  #
  #       (x + y).must == z
  #       x.must == y - 3
  #
  #       branch_on @vars
  #     end
  #   end
  # 
  # A model typically consists of three main parts:
  # [Variables] Variables specify how to view the problem. A solution is an 
  #             assignment of the variables. In the example above we created 
  #             an array of three integer variables with domains 0..9 and gave 
  #             it the name +variables+.
  #
  #             There are three types of variables: integer variables
  #             (Gecode::IntVar, can be assigned one of many
  #             possible integer values), boolean variables
  #             (Gecode::BoolVar, can be assigned either true or
  #             false) and set variables (Gecode::SetVar, can be
  #             assigned a set of integers).  Variables of the different
  #             types are constructed using #int_var, #int_var_array,
  #             #int_var_matrix, #bool_var, #bool_var_array,
  #             #bool_var_matrix, #set_var, #set_var_array and
  #             #set_var_matrix .
  #
  #             The various variables all have the functionality of Operand 
  #             and have many properties depending on their type. For 
  #             instance integer variables have the properties defined
  #             in Gecode::Int::IntOperand and
  #             enumerations of integer variables (such as the array
  #             +variables+ we used) have the properties defined in  
  #             Gecode::IntEnum::IntEnumOperand .
  #             
  # [Constraints] Constraints are placed on the variables to ensure that a 
  #               valid assignment of the variables must also be a solution.
  #               In the example above we constrained the variables so
  #               that all equations were satisfied (which is exactly when
  #               we have found a solution).
  #
  #               The various constraints that can be placed on the various
  #               kinds of operands are found in the respective
  #               constraint receivers. For instance, the constraints
  #               that can be placed on integer operands are found in 
  #               Gecode::Int::IntConstraintReceiver and
  #               the constraints that can be placed on enumerations of
  #               integer operands are found in 
  #               Gecode::IntEnum::IntEnumConstraintReceiver .
  #
  # [Branching] "branch_on variables" in the example tells Gecode that
  #             it should explore the search space until it has assigned
  #             +variables+ (or exhausted the search space). It also
  #             tells Gecode in what order the search space should be
  #             explore, which can have a big effect on the search
  #             performance. See #branch_on for details.
  #
  # == Finding solutions
  #
  # Solutions to a formulated problem are found are found by using
  # methods such as #solve!, #solution, #each_solution . If one wants to
  # find a solution that optimizes a certain quantity (i.e. maximizes a
  # certain variable) then one should have a look at #maximize!,
  # #minimize! and #optimize! .
  #
  # The first solution to the example above could for instance be found
  # using
  #
  #   puts EquationProblem.new.solve!.vars.values.join(', ')
  #
  # which would find the first solution to the problem, access the
  # assigned values of +variables+ and print them (in order x, y, z).
  #
  # == Shorter ways of formulating problems
  #
  # Problems can also be formulated without defining a new class by
  # using Gecode#solve et al.
  #
  # Additionally one can use "foo_is_an ..." to create an accessor of 
  # name foo, without having to use instance variables. The above
  # problem becomes
  #   class EquationProblem 
  #     include Gecode::Mixin
  #
  #     def initialize
  #       x, y, z = vars_is_an int_var_array(3, 0..9)
  #
  #       (x + y).must == z
  #       x.must == y - 3
  #
  #       branch_on vars
  #     end
  #   end
  #
  module Mixin
    # The largest integer allowed in the domain of an integer variable.
    MAX_INT = Gecode::Raw::IntLimits::MAX
    # The smallest integer allowed in the domain of an integer variable.
    MIN_INT = Gecode::Raw::IntLimits::MIN

    # The largest integer allowed in the domain of a set variable.
    SET_MAX_INT = Gecode::Raw::SetLimits::MAX
    # The smallest integer allowed in the domain of a set variable.
    SET_MIN_INT = Gecode::Raw::SetLimits::MIN

    # The largest possible domain for an integer variable.
    LARGEST_INT_DOMAIN = MIN_INT..MAX_INT
    # The largest possible domain, without negative integers, for an
    # integer variable.
    NON_NEGATIVE_INT_DOMAIN = 0..MAX_INT

    # The largest possible bound for a set variable.
    LARGEST_SET_BOUND = SET_MIN_INT..SET_MAX_INT

    # Creates a new integer variable with the specified domain. The domain can
    # either be a range, a single element, or an enumeration of elements. If no
    # domain is specified then the largest possible domain is used.
    def int_var(domain = LARGEST_INT_DOMAIN)
      args = domain_arguments(domain)
      IntVar.new(self, variable_creation_space.new_int_var(*args))
    end
    
    # Creates an array containing the specified number of integer variables 
    # with the specified domain. The domain can either be a range, a single 
    # element, or an enumeration of elements. If no domain is specified then 
    # the largest possible domain is used.
    def int_var_array(count, domain = LARGEST_INT_DOMAIN)
      args = domain_arguments(domain)
      build_var_array(count) do
        IntVar.new(self, variable_creation_space.new_int_var(*args))
      end
    end
    
    # Creates a matrix containing the specified number rows and columns of 
    # integer variables with the specified domain. The domain can either be a 
    # range, a single element, or an enumeration of elements. If no domain 
    # is specified then the largest possible domain is used.
    def int_var_matrix(row_count, col_count, domain = LARGEST_INT_DOMAIN)
      args = domain_arguments(domain)
      build_var_matrix(row_count, col_count) do
        IntVar.new(self, variable_creation_space.new_int_var(*args))
      end
    end
    
    # Creates a new boolean variable.
    def bool_var
      BoolVar.new(self, variable_creation_space.new_bool_var)
    end
    
    # Creates an array containing the specified number of boolean variables.
    def bool_var_array(count)
      build_var_array(count) do
        BoolVar.new(self, variable_creation_space.new_bool_var)
      end
    end
    
    # Creates a matrix containing the specified number rows and columns of 
    # boolean variables.
    def bool_var_matrix(row_count, col_count)
      build_var_matrix(row_count, col_count) do
        BoolVar.new(self, variable_creation_space.new_bool_var)
      end
    end
    
    # Creates a set variable with the specified domain for greatest lower bound
    # and least upper bound (specified as either a fixnum, range or enum). If 
    # no bounds are specified then the empty set is used as greatest lower 
    # bound and the largest possible set as least upper bound. 
    #
    # A range for the allowed cardinality of the set can also be
    # specified, if none is specified, or nil is given, then the default
    # range (anything) will be used. If only a single Fixnum is
    # specified as cardinality_range then it's used as lower bound.
    def set_var(glb_domain = [], lub_domain = LARGEST_SET_BOUND,
        cardinality_range = nil)
      args = set_bounds_to_parameters(glb_domain, lub_domain, cardinality_range)
      SetVar.new(self, variable_creation_space.new_set_var(*args))
    end
    
    # Creates an array containing the specified number of set variables. The
    # parameters beyond count are the same as for #set_var .
    def set_var_array(count, glb_domain = [], lub_domain = LARGEST_SET_BOUND, 
        cardinality_range = nil)
      args = set_bounds_to_parameters(glb_domain, lub_domain, cardinality_range)
      build_var_array(count) do
        SetVar.new(self, variable_creation_space.new_set_var(*args))
      end
    end
    
    # Creates a matrix containing the specified number of rows and columns 
    # filled with set variables. The parameters beyond row and column counts are
    # the same as for #set_var .
    def set_var_matrix(row_count, col_count, glb_domain = [], 
        lub_domain = LARGEST_SET_BOUND, cardinality_range = nil)
      args = set_bounds_to_parameters(glb_domain, lub_domain, cardinality_range)
      build_var_matrix(row_count, col_count) do
        SetVar.new(self, variable_creation_space.new_set_var(*args))
      end
    end
    
    # Retrieves the currently used space. Calling this method is only allowed 
    # when sanctioned by the model beforehand, e.g. when the model asks a 
    # constraint to post itself. Otherwise an RuntimeError is raised.
    #
    # The space returned by this method should never be stored, it should be
    # rerequested from the model every time that it's needed.
    def active_space #:nodoc:
      unless @gecoder_mixin_allow_space_access
        raise 'Space access is restricted and the permission to access the ' + 
          'space has not been given.'
      end
      selected_space
    end
    
    # Adds the specified constraint to the model. Returns the newly added 
    # constraint.
    def add_constraint(constraint) #:nodoc:
      add_interaction do
        constraint.post
      end
      return constraint
    end
    
    # Adds a block containing something that interacts with Gecode to a queue
    # where it is potentially executed.
    def add_interaction(&block) #:nodoc:
      gecode_interaction_queue << block
    end
    
    # Allows the model's active space to be accessed while the block is 
    # executed. Don't use this unless you know what you're doing. Anything that
    # the space is used for (such as bound variables) must be released before
    # the block ends.
    #
    # Returns the result of the block.
    def allow_space_access(&block) #:nodoc:
      # We store the old value so that nested calls don't become a problem, i.e.
      # access is allowed as long as one call to this method is still on the 
      # stack.
      old = @gecoder_mixin_allow_space_access
      @gecoder_mixin_allow_space_access = true
      res = yield
      @gecoder_mixin_allow_space_access = old
      return res
    end
    
    # Starts tracking a variable that depends on the space. All variables 
    # created should call this method for their respective models.
    def track_variable(variable) #:nodoc:
      (@gecoder_mixin_variables ||= []) << variable
    end

    def self.included(mod)
      mod.class_eval do
        alias_method :pre_gecoder_method_missing, :method_missing
        # Wraps method missing to handle #foo_is_a and #foo_is_an . 
        #
        # "<variable_name>_is_a <variable>" or "<variable_name>_is_an
        # <variable>", # replacing "<variable_name>" with the variable's
        # name and "<variable>" with the variable, adds an instance
        # variable and accessor with the specified name.
        #
        # The method also returns the variable given.
        #
        # ==== Example
        #
        #   # Add an instance variable and accessor named "foo" that return
        #   # the integer variable.
        #   foo_is_an int_var(0..9)
        #
        #   # Add an instance variable and accessor named "bar" that return
        #   # the boolean variable array.
        #   bar_is_a bool_var_array(2)
        def method_missing(method, *args)
          name = method.to_s
          if name =~ /._is_an?$/
            name.sub!(/_is_an?$/, '')
            unless args.size == 1
              raise ArgumentError, 
                "Wrong number of argmuments (#{args.size} for 1)."
            end 
            if respond_to? name
              raise ArgumentError, "Method with name #{name} already exists."
            end
            if instance_variable_defined? "@#{name}"
              raise ArgumentError, 
                "Instance variable with name @#{name} already exists."
            end

            # We use the meta class to avoid defining the variable in all
            # other instances of the class.
            eval <<-"end_eval"
              @#{name} = args.first
              class <<self
                attr :#{name}
              end
            end_eval
            return args.first
          else
            pre_gecoder_method_missing(method, *args)
          end
        end
        alias_method :mixin_method_missing, :method_missing

        def self.method_added(method)
          if method == :method_missing && !@redefining_method_missing
            # The class that is mixing in the mixin redefined method
            # missing. Redefine method missing again to combine the two
            # definitions.
            @redefining_method_missing = true
            class_eval do 
              alias_method :mixee_method_missing, :method_missing
              def combined_method_missing(*args)
                begin
                  mixin_method_missing(*args)
                rescue NoMethodError => e
                  mixee_method_missing(*args)
                end
              end
              alias_method :method_missing, :combined_method_missing
            end
          end
        end
      end
    end

    protected
    
    # Gets a queue of objects that can be posted to the model's active_space 
    # (by calling their post method).
    def gecode_interaction_queue #:nodoc:
      @gecode_interaction_queue ||= []
    end
    
    private
    
    # Creates an array containing the specified number of variables, all
    # constructed using the provided block..
    def build_var_array(count, &block)
      variables = []
      count.times do 
        variables << yield
      end
      return wrap_enum(variables)
    end
    
    # Creates a matrix containing the specified number rows and columns of 
    # variables, all constructed using the provided block. 
    def build_var_matrix(row_count, col_count, &block)
      rows = []
      row_count.times do |i|
        row = []
        col_count.times do |j|
          row << yield
        end
        rows << row
      end
      return wrap_enum(Util::EnumMatrix.rows(rows, false))
    end

    # Returns the array of arguments that correspond to the specified 
    # domain when given to Gecode. The domain can be given as a range, 
    # a single number, or an enumerable of elements. 
    def domain_arguments(domain)
      if domain.respond_to?(:first) and domain.respond_to?(:last) and
            domain.respond_to?(:exclude_end?)
        if domain.exclude_end?
          return [domain.first, (domain.last - 1)]
        else
          return [domain.first, domain.last]
        end
      elsif domain.kind_of? Enumerable
        array = domain.to_a
        return [Gecode::Raw::IntSet.new(array, array.size)]
      elsif domain.kind_of? Fixnum
        return [domain, domain]
      else
        raise TypeError, 'The domain must be given as an instance of ' +
          "Enumerable or Fixnum, but #{domain.class} was given."
      end
    end
    
    # Transforms the argument to a set cardinality range, returns nil if the
    # default range should be used. If arg is a range then that's used, 
    # otherwise if the argument is a fixnum it's used as lower bound.
    def to_set_cardinality_range(arg)
      if arg.kind_of? Fixnum
        arg..Gecode::Raw::SetLimits::MAX
      else
        arg
      end
    end
    
    # Converts the specified set var domain to parameters accepted by
    # Gecode. The bounds can be specified as a fixnum, range or # enum. 
    # The parameters are returned as an array.
    def set_bounds_to_parameters(glb_domain, lub_domain, cardinality_range)
      check_set_bounds(glb_domain, lub_domain)
      args = []
      args << Gecode::Util.constant_set_to_int_set(glb_domain)
      args << Gecode::Util.constant_set_to_int_set(lub_domain)
      card_range = to_set_cardinality_range(cardinality_range)
      if card_range.nil?
        card_range = 0..Gecode::Raw::SetLimits::CARD
      end
      args << card_range.first << card_range.last
    end
    
    # Checks whether the specified greatest lower bound is a subset of least 
    # upper bound. Raises ArgumentError if that is not the case.
    def check_set_bounds(glb, lub)
      unless valid_set_bounds?(glb, lub)
        raise ArgumentError, 
          "Invalid set bounds: #{glb} is not a subset of #{lub}."
      end
    end
    
    # Returns whether the greatest lower bound is a subset of least upper 
    # bound.
    def valid_set_bounds?(glb, lub)
      return true if glb.respond_to?(:empty?) and glb.empty? 
      if glb.kind_of?(Range) and lub.kind_of?(Range)
        glb.first >= lub.first and glb.last <= lub.last
      else
        glb = [glb] if glb.kind_of?(Fixnum)
        lub = [lub] if lub.kind_of?(Fixnum)
        (glb.to_a - lub.to_a).empty?
      end
    end
    
    # Retrieves the base from which searches are made. 
    def base_space
      @gecoder_mixin_base_space ||= Gecode::Raw::Space.new
    end
    
    # Retrieves the currently selected space, the one which constraints and 
    # variables should be bound to.
    def selected_space
      return @gecoder_mixin_active_space unless @gecoder_mixin_active_space.nil?
      self.active_space = base_space
    end
    
    # Retrieves the space that should be used for variable creation.
    def variable_creation_space
      @gecoder_mixin_variable_creation_space || selected_space
    end
    
    # Executes any interactions with Gecode still waiting in the queue 
    # (emptying the queue) in the process.
    def perform_queued_gecode_interactions
      allow_space_access do
        gecode_interaction_queue.each{ |con| con.call }
        gecode_interaction_queue.clear # Empty the queue.
      end
    end
    
    # Switches the active space used (the space from which variables are read
    # and to which constraints are posted). @gecoder_mixin_active_space 
    # should never be assigned directly.
    def active_space=(new_space)
      @gecoder_mixin_active_space = new_space
    end
  end
end
