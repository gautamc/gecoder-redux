module Gecode::Set
  module SetOperand
    # Produces an IntOperand representing the minimum of the set.
    #
    # ==== Examples 
    #
    #  # The minimum of +set+.
    #  set.min
    def min
      Connection::SetMinOperand.new(@model, self)
    end
    
    # Produces an IntOperand representing the maximum of the set.
    #
    # ==== Examples 
    #
    #  # The maximum of +set+.
    #  set.max
    def max
      Connection::SetMaxOperand.new(@model, self)
    end
    
    # Produces an IntOperand representing the sum of the values in the
    # set. One of the following options may also be given:
    # [:weights]       Produces the weighted sum using the specified hash 
    #                  of weights. The hash should map each value to 
    #                  that value's weight.
    # [:substitutions] Produces the sum of the set with all elements 
    #                  replaced according to the hash.
    # 
    # Elements not included in the weights or substitutions hash are 
    # removed from the upper bound of the set.
    #
    # ==== Examples 
    #
    #   # The sum of +set+.
    #   set.sum
    #
    #   # The sum of +set+ with primes < 10 given twice the weight.
    #   set.sum(:weights => {2 => 2, 3 => 2, 5 => 2, 7 => 2})
    #
    #   # The sum of +set+ with odd values in [1,6] being counted as 1.
    #   set.sum(:substitutions => {1 => 1, 3 => 1, 5 => 1})
    def sum(options = {:weights => weights = Hash.new(1)})
      if options.empty? or options.keys.size > 1
        raise ArgumentError, 'At most one of the options :weights and ' +
          ':substitutions may be specified.'
      end

      case options.keys.first
        when :substitutions
          subs = options[:substitutions]
        when :weights
          weights = options[:weights]
          subs = Hash.new do |hash, key|
            if weights[key].nil?
              hash[key] = nil
            else
              hash[key] = key * weights[key]
            end
          end
        else raise ArgumentError, "Unrecognized option #{options.keys.first}."
      end
      Connection::SetSumOperand.new(@model, self, subs)
    end
  end
  
  # A module that gathers the classes and modules used in connection 
  # constraints.
  module Connection #:nodoc:
    class SetMinOperand < Gecode::Int::ShortCircuitEqualityOperand #:nodoc:
      def initialize(model, set_op)
        super model
        @set = set_op
      end

      def constrain_equal(int_operand, constrain, propagation_options)
        set = @set.to_set_var
        if constrain
          int_operand.must_be.in set.upper_bound.min..set.lower_bound.min
        end
        
        Gecode::Raw::min(@model.active_space, set.bind, 
          int_operand.to_int_var.bind)
      end
    end
    
    class SetMaxOperand < Gecode::Int::ShortCircuitEqualityOperand #:nodoc:
      def initialize(model, set_op)
        super model
        @set = set_op
      end

      def constrain_equal(int_operand, constrain, propagation_options)
        set = @set.to_set_var
        if constrain
          int_operand.must_be.in set.upper_bound.min..set.lower_bound.min
        end
        
        Gecode::Raw::max(@model.active_space, set.bind, 
          int_operand.to_int_var.bind)
      end
    end
    
    class SetSumOperand < Gecode::Int::ShortCircuitEqualityOperand #:nodoc:
      def initialize(model, set_op, subs)
        super model
        @set = set_op
        @subs = subs
      end

      def constrain_equal(int_operand, constrain, propagation_options)
        set = @set.to_set_var
        lub = set.upper_bound.to_a
        lub.delete_if{ |e| @subs[e].nil? }
        substituted_lub = lub.map{ |e| @subs[e] }
        if constrain
          # Compute the theoretical bounds of the weighted sum. This is slightly
          # sloppy since we could also use the contents of the greatest lower 
          # bound.
          min = substituted_lub.find_all{ |e| e < 0}.inject(0){ |x, y| x + y }
          max = substituted_lub.find_all{ |e| e > 0}.inject(0){ |x, y| x + y }
          int_operand.must_be.in min..max
        end

        Gecode::Raw::weights(@model.active_space, lub, substituted_lub, 
          set.bind, int_operand.to_int_var.bind)
      end
    end
  end
end
