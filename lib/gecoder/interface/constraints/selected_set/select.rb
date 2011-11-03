module Gecode::SelectedSet
  class SelectedSetOperand
    # Produces a SetOperand representing the selected sets' union.
    #
    # ==== Examples 
    #
    #   # The union of all sets selected by +set_enum[set]+.
    #   set_enum[set].union
    def union
      Element::SelectedSetUnionOperand.new(model, self)
    end
     
    # Produces a SetOperand representing the selected sets' intersection.
    # The option :with can be used to enumerate the elements in the
    # universe.
    #
    # ==== Examples 
    #
    #   # The intersection of all sets selected by +set_enum[set]+.
    #   set_enum[set].intersection
    #
    #   # The same intersection as above, but with [3,5,7] as universe.
    #   set_enum[set].intersection(:with => [3,5,7])
    def intersection(options = {})
      universe = nil
      unless options.empty? 
        unless options.size == 1 and options.has_key?(:with)
          raise ArgumentError, "Expected option key :with, got #{options.keys}."
        else
          universe = options[:with]
          unless universe.kind_of?(Enumerable) and 
              universe.all?{ |element| element.kind_of? Fixnum }
            raise TypeError, "Expected the universe to be specified as " + 
              "an enumeration of fixnum, got #{universe.class}."
          end
        end
      end
      
      Element::SelectedSetIntersectionOperand.new(model, self, universe)
    end
  end

  class SelectedSetConstraintReceiver
    # Constrains the selected sets to be pairwise disjoint.
    #
    # ==== Examples 
    #
    #   # Constrains all sets selected by +set_enum[set]+ to be pairwise
    #   # disjoint.
    #   set_enum[set].must_be.disjoint 
    def disjoint(options = {})
      if @params[:negate]
        raise Gecode::MissingConstraintError, 'A negated disjoint constraint ' + 
          'is not implemented.'
      end
      if options.has_key? :reify
        raise ArgumentError, 'The disjoint constraint does not support the ' + 
          'reification option.'
      end

      @params.update Gecode::Set::Util.decode_options(options)
      @model.add_constraint Element::DisjointConstraint.new(@model, @params)
    end
  end

  module Element #:nodoc:
    class SelectedSetUnionOperand < Gecode::Set::ShortCircuitEqualityOperand #:nodoc:
      def initialize(model, selected_set)
        super model
        @selected_set = selected_set
      end

      def constrain_equal(set_operand, constrain, propagation_options)
        enum, indices = @selected_set.to_selected_set
        if constrain
          set_operand.must_be.subset_of enum.upper_bound_range
        end
        
        Gecode::Raw::elementsUnion(@model.active_space, 
          enum.to_set_enum.bind_array, indices.to_set_var.bind, 
          set_operand.to_set_var.bind)
      end
    end
    
    class SelectedSetIntersectionOperand < Gecode::Set::ShortCircuitEqualityOperand #:nodoc:
      def initialize(model, selected_set, universe)
        super model
        @selected_set = selected_set
        @universe = universe
      end

      def constrain_equal(set_operand, constrain, propagation_options)
        enum, indices = @selected_set.to_selected_set
        universe = @universe

        # We can't do any useful constraining here since the empty intersection
        # is the universe.

        if universe.nil?
          Gecode::Raw::elementsInter(@model.active_space, 
            enum.to_set_enum.bind_array, indices.to_set_var.bind, 
            set_operand.to_set_var.bind)
        else
          Gecode::Raw::elementsInter(@model.active_space,  
            enum.to_set_enum.bind_array, indices.to_set_var.bind, 
            set_operand.to_set_var.bind,
            Gecode::Util.constant_set_to_int_set(universe))
        end
      end
    end
    
    class DisjointConstraint < Gecode::Constraint #:nodoc:
      def post
        enum, indices = @params[:lhs].to_selected_set
        Gecode::Raw.elementsDisjoint(@model.active_space, 
          enum.to_set_enum.bind_array, indices.to_set_var.bind)
      end
    end
  end
end
