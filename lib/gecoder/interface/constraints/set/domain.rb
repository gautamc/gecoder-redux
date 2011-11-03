module Gecode::Set
  class SetConstraintReceiver
    # Constrains the set operand to have a domain equal to +constant_set+.
    # 
    # ==== Examples 
    # 
    #   # +set+ must equal [1,2,5]
    #   set.must == [1,2,5]
    #   
    #   # +set+ must not equal 1..67
    #   set.must_not == 1..67
    #   
    #   # +set+ must equal the singleton set 0. The constraint is reified with
    #   # the boolean operand +is_singleton_zero+.
    #   set.must.equal(0, :reify => is_singleton_zero)
    def ==(constant_set, options = {})
      add_domain_constraint(:==, constant_set, options)
    end

    # Constrains the set operand to be a superset of +constant_set+.
    #
    # ==== Examples 
    # 
    #   # +set+ must be a superset of [1,2,5]
    #   set.must_be.superset_of [1,2,5]
    #   
    #   # +set+ must be a superset of 1..67
    #   set.must_be.superset_of 1..67
    #   
    #   # +set+ must not be a superset of [0].
    #   set.must_not_be.superset_of 0
    #   
    #   # +set+ must be a superset of [1,3,5,7]. The constraint is reified with
    #   # the boolean operand +bool+.
    #   set.must_be.superset_of([1.3.5.7], :reify => bool) 
    def superset(constant_set, options = {})
      add_domain_constraint(:superset, constant_set, options)
    end

    # Constrains the set operand to be a subset of +constant_set+.
    # 
    # ==== Examples 
    # 
    #   # +set+ must be a subset of [1,2,5]
    #   set.must_be.subset_of [1,2,5]
    #   
    #   # +set+ must be a subset of 1..67
    #   set.must_be.subset_of 1..67
    #   
    #   # +set+ must not be a subset of [0].
    #   set.must_not_be.subset_of 0
    #   
    #   # +set+ must be a subset of [1,3,5,7]. The constraint is reified with
    #   # the boolean operand +bool+.
    #   set.must_be.subset_of([1.3.5.7], :reify => bool) 
    def subset(constant_set, options = {})
      add_domain_constraint(:subset, constant_set, options)
    end

    # Constrains the set operand to be disjoint with +constant_set+.
    # 
    # ==== Examples 
    # 
    #   # +set+ must be disjoint with [1,2,5]
    #   set.must_be.disjoint_with [1,2,5]
    #   
    #   # +set+ must be disjoint with 1..67
    #   set.must_be.disjoint_with 1..67
    #   
    #   # +set+ must not be disjoint with [0].
    #   set.must_not_be.disjoint_with 0
    #   
    #   # +set+ must be disjoint with [1,3,5,7]. The constraint is reified with
    #   # the boolean operand +bool+.
    #   set.must_be.disjoint_with([1.3.5.7], :reify => bool) 
    def disjoint(constant_set, options = {})
      add_domain_constraint(:disjoint, constant_set, options)
    end

    # Constrains the set operand to be the complement of +constant_set+.
    #
    # ==== Examples 
    # 
    #   # +set+ must be the complement of [1,2,5]
    #   set.must_be.complement_of [1,2,5]
    #   
    #   # +set+ must be the complement of 1..67
    #   set.must_be.complement_of 1..67
    #   
    #   # +set+ must not be the complement of [0].
    #   set.must_not_be.complement_of 0
    #   
    #   # +set+ must be the complement of [1,3,5,7]. The constraint is 
    #   # reified with the boolean operand +bool+.
    #   set.must_be.complement_of([1.3.5.7], :reify => bool) 
    def complement(constant_set, options = {})
      add_domain_constraint(:complement, constant_set, options)
    end

    alias_set_methods
    
    private
    
    # Adds a domain constraint for the specified relation name, constant set
    # and options.
    def add_domain_constraint(relation_name, constant_set, options)
      unless Gecode::Util.constant_set? constant_set
        raise TypeError, "Expected constant set, got #{constant_set.class}."
      end
      @params[:rhs] = constant_set
      @params[:relation] = relation_name
      @params.update Gecode::Set::Util.decode_options(options)
      if relation_name == :==
        @model.add_constraint Domain::EqualityDomainConstraint.new(@model, 
          @params)
      else
        @model.add_constraint Domain::DomainConstraint.new(@model, @params)
      end
    end
  end
  
  # A module that gathers the classes and modules used in domain constraints.
  module Domain #:nodoc:
    class EqualityDomainConstraint < Gecode::ReifiableConstraint #:nodoc:
      def post
        var, domain, reif_var, negate = @params.values_at(:lhs, :rhs, :reif, 
          :negate)
        if negate
          rel_type = Gecode::Util::NEGATED_SET_RELATION_TYPES[:==]
        else
          rel_type = Gecode::Util::SET_RELATION_TYPES[:==]
        end
        
        (params = []) << var.to_set_var.bind
        params << rel_type
        params << Gecode::Util.constant_set_to_params(domain)
        params << reif_var.to_bool_var.bind if reif_var.respond_to? :to_bool_var
        Gecode::Raw::dom(@model.active_space, *params.flatten)
      end
    end
  
    class DomainConstraint < Gecode::ReifiableConstraint #:nodoc:
      def post
        var, domain, reif_var, relation = @params.values_at(:lhs, :rhs, :reif, 
          :relation)
        
        (params = []) << var.to_set_var.bind
        params << Gecode::Util::SET_RELATION_TYPES[relation]
        params << Gecode::Util.constant_set_to_params(domain)
        params << reif_var.to_bool_var.bind if reif_var.respond_to? :to_bool_var
        Gecode::Raw::dom(@model.active_space, *params.flatten)
      end
      negate_using_reification
    end
  end
end
