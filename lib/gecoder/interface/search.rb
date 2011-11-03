module Gecode
  # An exception raised when a search failed because there are no
  # solutions.
  class NoSolutionError < RuntimeError
    def initialize #:nodoc:
      super('No solution could be found.')
    end
  end
  
  # An exception raised when a search has been aborted due to e.g.
  # hitting the time limit specified when initiating the search.
  class SearchAbortedError < RuntimeError
    def initialize #:nodoc:
      super('The search was aborted before a solution could be found.')
    end
  end

  module Mixin
    # Finds the first solution to the modelled problem and updates the variables
    # to that solution. The found solution is also returned. Raises
    # Gecode::NoSolutionError if no solution can be found.
    #
    # The following options can be specified in a hash with symbols as
    # keys when calling the method:
    # 
    # [:time_limit] The number of milliseconds that the solver should be
    #               allowed to use when searching for a solution. If it can 
    #               not find a solution fast enough, then 
    #               Gecode::SearchAbortedError is raised.
    def solve!(options = {})
      dfs = dfs_engine(options)
      space = dfs.next
      @gecoder_mixin_statistics = dfs.statistics
      raise Gecode::SearchAbortedError if dfs.stopped
      raise Gecode::NoSolutionError if space.nil?
      self.active_space = space
      return self
    end
    
    # Returns to the original state, before any search was made (but 
    # propagation might have been performed). Returns the reset model.
    def reset!
      self.active_space = base_space
      @gecoder_mixin_statistics = nil
      return self
    end
    
    # Yields the first solution (if any) to the block. If no solution is found
    # then the block is not used. Returns the result of the block (nil in case
    # the block wasn't run). 
    def solution(&block)
      begin
        solution = self.solve!
        res = yield solution
        self.reset!
        return res
      rescue Gecode::NoSolutionError
        return nil
      end
    end
    
    # Yields each solution that the model has.
    def each_solution(&block)
      dfs = dfs_engine
      next_solution = nil
      while not (next_solution = dfs.next).nil?
        self.active_space = next_solution
        @gecoder_mixin_statistics = dfs.statistics
        yield self
      end
      self.reset!
    end
    
    # Returns search statistics providing various information from Gecode about
    # the search that resulted in the model's current variable state. If the 
    # model's variables have not undergone any search then nil is returned. The 
    # statistics is a hash with the following keys:
    # [:propagations]   The number of propagation steps performed.
    # [:failures]       The number of failed nodes in the search tree.
    # [:clones]         The number of clones created.
    # [:commits]        The number of commit operations performed.
    # [:memory]         The peak memory allocated to Gecode.
    def search_stats
      return nil if @gecoder_mixin_statistics.nil?
      
      return {
        :propagations => @gecoder_mixin_statistics.propagate,
        :failures     => @gecoder_mixin_statistics.fail,
        :clones       => @gecoder_mixin_statistics.clone,
        :commits      => @gecoder_mixin_statistics.commit,
        :memory       => @gecoder_mixin_statistics.memory
      }
    end
    
    # Finds the optimal solution. Optimality is defined by the provided
    # block which is given two parameters, the model and the best
    # solution found so far to the problem. The block should constrain
    # the model so that that only "better" solutions can be new
    # solutions. For instance if one wants to optimize a variable named
    # price (accessible from the model) to be as low as possible then
    # one should write the following.
    #
    #   model.optimize! do |model, best_so_far|
    #     model.price.must < best_so_far.price.value
    #   end
    #
    # Raises Gecode::NoSolutionError if no solution can be found.
    def optimize!(&block)
      # Execute constraints.
      perform_queued_gecode_interactions

      # Set the method used for constrain calls by the BAB-search.
      Mixin.constrain_proc = lambda do |home_space, best_space|
        self.active_space = best_space
        @gecoder_mixin_variable_creation_space = home_space
        yield(self, self)
        self.active_space = home_space
        @gecoder_mixin_variable_creation_space = nil
        
        perform_queued_gecode_interactions
      end

      # Perform the search.
      options = Gecode::Raw::Search::Options.new
      options.c_d = Gecode::Raw::Search::Config::MINIMAL_DISTANCE
      options.a_d = Gecode::Raw::Search::Config::ADAPTIVE_DISTANCE
      options.stop = nil
      bab = Gecode::Raw::BAB.new(selected_space, options)
      
      result = nil
      previous_solution = nil
      until (previous_solution = bab.next).nil?
        result = previous_solution
      end
      @gecoder_mixin_statistics = bab.statistics
      
      # Reset the method used constrain calls and return the result.
      Mixin.constrain_proc = nil
      raise Gecode::NoSolutionError if result.nil?
      
      # Switch to the result.
      self.active_space = result
      return self
    end
    
    # Finds the solution that maximizes a given integer variable. The name of 
    # the method that accesses the variable from the model should be given. To 
    # for instance maximize a variable named "profit", that's accessible 
    # through the model, one would use the following.
    #
    #   model.maximize! :profit
    #
    # Raises Gecode::NoSolutionError if no solution can be found.
    def maximize!(var)
      variable = self.method(var).call
      unless variable.kind_of? Gecode::IntVar
        raise ArgumentError.new("Expected integer variable, got #{variable.class}.")
      end
      
      optimize! do |model, best_so_far|
        model.method(var).call.must > best_so_far.method(var).call.value
      end
    end
    
    # Finds the solution that minimizes a given integer variable. The name of 
    # the method that accesses the variable from the model should be given. To 
    # for instance minimize a variable named "cost", that's accessible through 
    # the model, one would use the following.
    #
    #   model.minimize! :cost
    #
    # Raises Gecode::NoSolutionError if no solution can be found.
    def minimize!(var)
      variable = self.method(var).call
      unless variable.kind_of? Gecode::IntVar
        raise ArgumentError.new("Expected integer variable, got #{variable.class}.")
      end
      
      optimize! do |model, best_so_far|
        model.method(var).call.must < best_so_far.method(var).call.value
      end
    end
    
    class <<self 
      # Sets the proc that should be used to handle constrain requests.
      def constrain_proc=(proc) #:nodoc:
        @constrain_proc = proc
      end
    
      # Called by spaces when they want to constrain as part of BAB-search.
      def constrain(home, best) #:nodoc:
        if @constrain_proc.nil?
          raise NotImplementedError, 'Constrain method not implemented.' 
        else
          @constrain_proc.call(home, best)
        end
      end
    end
    
    private
    
    # Creates a depth first search engine for search, executing any 
    # unexecuted constraints first.
    def dfs_engine(options = {})
      # Execute constraints.
      perform_queued_gecode_interactions
      
      # Begin constructing the option struct.
      opt_struct = Gecode::Raw::Search::Options.new
      opt_struct.c_d = Gecode::Raw::Search::Config::MINIMAL_DISTANCE
      opt_struct.a_d = Gecode::Raw::Search::Config::ADAPTIVE_DISTANCE

      # Decode the options.
      if options.has_key? :time_limit
        opt_struct.stop = Gecode::Raw::Search::Stop.new(-1, options.delete(:time_limit), -1)
      else
        opt_struct.stop = nil
      end
      
      unless options.empty?
        raise ArgumentError, 'Unrecognized search option: ' + 
          options.keys.first.to_s
      end

      # Construct the engine.
      Gecode::Raw::DFS.new(selected_space, opt_struct)
    end
  end
end
