module Gecode::Int
  class IntConstraintReceiver
    # Creates a domain constraint using the specified domain, specified
    # as an enumeration of integers. The integer operand is constrained
    # to take a value in the domain.  Domains should be specified as
    # ranges if possible.
    # 
    # ==== Examples 
    # 
    #   # +x+ must be in the range 1..10
    #   x.must_be.in 1..10
    #   
    #   # +x+ must not be in the range -5...5
    #   x.must_not_be.in -5...5
    #   
    #   # Specifies the above, but reifies the constraint with the boolean 
    #   # operand +bool+ and specified +value+ as strength.
    #   x.must_not_be.in(-5...5, :reify => bool, :strength => :value)
    #
    #   # +x+ must be in the enumeration [3,5,7].
    #   x.must_be.in [3,5,7]
    #   
    #   # +x+ must not be in the enumeration [5,6,7,17].
    #   x.must_not_be.in [5,6,7,17]
    #   
    #   # Specifies the above, but reifies the constraint with the boolean 
    #   # operand +bool+ and specified +value+ as strength.
    #   x.must_not_be.in([5,6,7,17], :reify => bool, :strength => :value)
    #
    def in(domain, options = {})
      @params.update(Gecode::Util.decode_options(options))
      @params[:domain] = domain
      if domain.kind_of? Range
        @model.add_constraint Domain::RangeDomainConstraint.new(@model, @params)
      elsif domain.kind_of?(Enumerable) and domain.all?{ |e| e.kind_of? Fixnum }
        @model.add_constraint Domain::EnumDomainConstraint.new(@model, 
          @params)
      else
        raise TypeError, "Expected integer enumerable, got #{domain.class}."
      end
    end
  end
  
  # A module that gathers the classes and modules used in domain constraints.
  module Domain #:nodoc:
    # Range domain constraints specify that an integer operand must be 
    # contained within a specified range of integers.
    class RangeDomainConstraint < Gecode::ReifiableConstraint #:nodoc:
      def post
        var, domain, reif_var = @params.values_at(:lhs, :domain, :reif)
          
        (params = []) << var.to_int_var.bind
        last = domain.last
        last -= 1 if domain.exclude_end?
        params << domain.first << last
        params << reif_var.to_bool_var.bind if reif_var.respond_to? :to_bool_var
        params.concat propagation_options
        
        Gecode::Raw::dom(@model.active_space, *params)
      end
      negate_using_reification
    end
    
    # Enum domain constraints specify that an integer operand must be contained
    # in an enumeration of integers.
    class EnumDomainConstraint < Gecode::ReifiableConstraint #:nodoc:
      def post
        var, domain, reif_var = @params.values_at(:lhs, :domain, :reif)
        
        (params = []) << var.to_int_var.bind
        params << Gecode::Util.constant_set_to_int_set(domain)
        params << reif_var.to_bool_var.bind if reif_var.respond_to? :to_bool_var
        params.concat propagation_options
        
        Gecode::Raw::dom(@model.active_space, *params)
      end
      negate_using_reification
    end
  end
end
