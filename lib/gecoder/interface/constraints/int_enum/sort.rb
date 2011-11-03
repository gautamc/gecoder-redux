module Gecode::IntEnum
  class IntEnumConstraintReceiver
    # Constrains the elements in this enumeration to be sorted in ascending 
    # order. The following options can be given in addition to the
    # common constraint options:
    # 
    # [:as]     Defines a target (must be an IntEnum) that will
    #           hold the sorted version of the original enumerable. The original
    #           enumerable will not be affected (i.e. will not necessarily be 
    #           sorted)
    # [:order]  Sets an IntEnum that should be used to store the
    #           order of the original enum's operands when sorted. The original
    #           enumerable will not be affected (i.e. will not necessarily be 
    #           sorted)
    # 
    # If neither of those options are specified then the original enumerable
    # will be constrained to be sorted (otherwise not). Sort constraints with
    # options do not allow negation.
    #
    # ==== Examples 
    #
    #   # Constrain +numbers+ to be sorted.
    #   numbers.must_be.sorted
    #
    #   # Constrain +numbers+ to not be sorted.
    #   numbers.must_not_be.sorted
    # 
    #   # Constrain +sorted_numbers+ to be a sorted version of +numbers+. 
    #   numbers.must_be.sorted(:as => sorted_numbers)
    #
    #   # Constrain +order+ to be the order in which +numbers+ has to be
    #   # ordered to be sorted.
    #   numbers.must_be.sorted(:order => order)
    #   
    #   # Constrain +sorted_numbers+ to be +numbers+ sorted in the order 
    #   # described by the IntEnum +order+. 
    #   numbers.must_be.sorted(:as => sorted_numbers, :order => order)
    #
    #   # Constrains +numbers+ to be sorted, reifying with the boolean 
    #   # operand +is_sorted+, while selecting +domain+ as strength.
    #   numbers.must_be.sorted(:reify => :is_sorted, :strength => :domain)
    def sorted(options = {})
      # Extract and check options.
      target = options.delete(:as)
      order = options.delete(:order)
      unless target.nil? or target.respond_to? :to_int_enum
        raise TypeError, 'Expected int var enum as :as, got ' + 
          "#{target.class}."
      end
      unless order.nil? or order.respond_to? :to_int_enum
        raise TypeError, 'Expected int var enum as :order, got ' + 
          "#{order.class}."
      end
      
      # Extract standard options and convert to constraint.
      reified = !options[:reify].nil?
      @params.update(Gecode::Util.decode_options(options))
      if target.nil? and order.nil?
        @model.add_constraint Sort::SortConstraint.new(@model, @params)
      else
        # Do not allow negation.
        if @params[:negate]
          raise Gecode::MissingConstraintError, 'A negated sort with options ' +
            'is not implemented.'
        end
        if reified
          raise ArgumentError, 'Reification is not supported by the sorted ' + 
            'constraint.'
        end
      
        @params.update(:target => target, :order => order)
        @model.add_constraint Sort::SortConstraintWithOptions.new(@model, 
          @params)
      end
    end
  end

  # A module that gathers the classes and modules used in sort constraints.
  module Sort #:nodoc:
    class SortConstraintWithOptions < Gecode::Constraint #:nodoc:
      def post
        if @params[:target].nil?
          # We must have a target.
          lhs = @params[:lhs].to_int_enum
          @params[:target] = @model.int_var_array(lhs.size, lhs.domain_range)
        end
        
        # Prepare the parameters.
        params = @params.values_at(:lhs, :target, :order).map do |param| 
          if param.respond_to? :to_int_enum
            param.to_int_enum.bind_array
          else
            param
          end
        end.delete_if{ |param| param.nil? }
        params.concat propagation_options
        
        # Post the constraint.
        Gecode::Raw::sorted(@model.active_space, *params)
      end
    end
    
    class SortConstraint < Gecode::ReifiableConstraint #:nodoc:
      def post
        lhs, strength, kind, reif_var = 
          @params.values_at(:lhs, :strength, :kind, :reif)
        using_reification = !reif_var.nil?
        
        # We translate the constraint into n-1 relation constraints.
        options = {
          :strength => 
            Gecode::Util::PROPAGATION_STRENGTHS.invert[strength],
          :kind => 
            Gecode::Util::PROPAGATION_KINDS.invert[kind]
        }
        if using_reification
          reification_variables = @model.bool_var_array(lhs.size - 1)
        end
        (lhs.size - 1).times do |i|
          first, second = lhs[i, 2]
          rel_options = options.clone
          if using_reification
            # Reify each relation constraint and then bind them all together.
            rel_options[:reify] = reification_variables[i]
          end
          first.must_be.less_than_or_equal_to(second, rel_options)
        end
        if using_reification
          reification_variables.conjunction.must == reif_var
        end
      end
      negate_using_reification
    end
  end
end
