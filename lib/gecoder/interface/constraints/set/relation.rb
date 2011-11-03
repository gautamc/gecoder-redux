module Gecode::Set
  class SetConstraintReceiver
    alias_method :pre_relation_equality, :==
    # Constrains the set operand to equal +set_operand+.
    # 
    # ==== Examples 
    # 
    #   # +set1+ must equal +set2+
    #   set1.must == set2
    #   
    #   # +set1+ must equal +set2+. Reify the constraint with the
    #   # boolean operand +bool+.
    #   set1.must.equal(set2, :reify => bool)
    def ==(set_operand, options = {})
      if set_operand.respond_to? :to_set_var
        add_relation_constraint(:==, set_operand, options)
      else
        pre_relation_equality(set_operand, options)
      end
    end

    alias_method :pre_relation_superset, :superset
    # Constrains the set operand to be a superset of +set_operand+.
    # 
    # ==== Examples 
    # 
    #   # +set1+ must be a superset of +set2+
    #   set1.must_be.superset_of set2
    #   
    #   # +set1+ must be a superset of +set2+. Reify the constraint 
    #   # with the boolean operand +bool+.
    #   set1.must_be.superset(set2, :reify => bool)
    def superset(set_operand, options = {})
      if set_operand.respond_to? :to_set_var
        add_relation_constraint(:superset, set_operand, options)
      else
        pre_relation_superset(set_operand, options)
      end
    end

    alias_method :pre_relation_subset, :subset
    # Constrains the set operand to be a subeset of +set_operand+.
    # 
    # ==== Examples 
    # 
    #   # +set1+ must be a subset of +set2+
    #   set1.must_be.subset_of == set2
    #   
    #   # +set1+ must be a subset of +set2+. Reify the constraint 
    #   # with the boolean operand +bool+.
    #   set1.must_be.subset(set2, :reify => bool)
    def subset(set_operand, options = {})
      if set_operand.respond_to? :to_set_var
        add_relation_constraint(:subset, set_operand, options)
      else
        pre_relation_subset(set_operand, options)
      end
    end

    alias_method :pre_relation_disjoint, :disjoint
    # Constrains the set operand to be disjoint with +set_operand+.
    # 
    # ==== Examples 
    # 
    #   # +set1+ must be disjoint with +set2+
    #   set1.must_be.disjoint_with set2
    #   
    #   # +set1+ must be disjoint with +set2+. Reify the constraint 
    #   # with the boolean operand +bool+.
    #   set1.must_be.disjoint(set2, :reify => bool)
    def disjoint(set_operand, options = {})
      if set_operand.respond_to? :to_set_var
        add_relation_constraint(:disjoint, set_operand, options)
      else
        pre_relation_disjoint(set_operand, options)
      end
    end

    alias_method :pre_relation_complement, :complement
    # Constrains the set operand to be the complement of +set_operand+.
    # 
    # ==== Examples 
    # 
    #   # +set1+ must be the complement of +set2+
    #   set1.must_be.complement_of set2
    #   
    #   # +set1+ must be the complement of +set2+. Reify the constraint 
    #   # with the boolean operand +bool+.
    #   set1.must_be.complement(set2, :reify => bool)
    def complement(set_operand, options = {})
      if set_operand.respond_to? :to_set_var
        add_relation_constraint(:complement, set_operand, options)
      else
        pre_relation_complement(set_operand, options)
      end
    end

    alias_set_methods
    
    private
    
    # Adds a relation constraint for the specified relation name, set
    # operand and options.
    def add_relation_constraint(relation_name, set, options)
      @params[:rhs] = set
      @params[:relation] = relation_name
      @params.update Gecode::Set::Util.decode_options(options)
      if relation_name == :==
        @model.add_constraint Relation::EqualityRelationConstraint.new(@model, 
          @params)
      else
        @model.add_constraint Relation::RelationConstraint.new(@model, @params)
      end
    end
  end
  
  # A module that gathers the classes and modules used in relation constraints.
  module Relation #:nodoc:
    class EqualityRelationConstraint < Gecode::ReifiableConstraint #:nodoc:
      def post
        lhs, rhs, reif_var, negate = @params.values_at(:lhs, :rhs, :reif, 
          :negate)
        if negate
          rel_type = Gecode::Util::NEGATED_SET_RELATION_TYPES[:==]
        else
          rel_type = Gecode::Util::SET_RELATION_TYPES[:==]
        end
        
        (params = []) << lhs.to_set_var.bind
        params << rel_type
        params << rhs.to_set_var.bind
        if reif_var.respond_to? :to_bool_var
          params << reif_var.to_bool_var.bind 
        end
        Gecode::Raw::rel(@model.active_space, *params)
      end
    end
  
    class RelationConstraint < Gecode::ReifiableConstraint #:nodoc:
      def post
        lhs, rhs, reif_var, relation = @params.values_at(:lhs, :rhs, :reif, 
          :relation)
        
        (params = []) << lhs.to_set_var.bind
        params << Gecode::Util::SET_RELATION_TYPES[relation]
        params << rhs.to_set_var.bind
        if reif_var.respond_to? :to_bool_var
          params << reif_var.to_bool_var.bind 
        end
        Gecode::Raw::rel(@model.active_space, *params)
      end
      negate_using_reification
    end
  end
end
