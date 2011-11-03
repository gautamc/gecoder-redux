module Gecode::SetElements
  class SetElementsConstraintReceiver
    # Constrains the set elements to equal +operand+ (either a
    # constant integer or an integer operand).
    #
    # ==== Examples 
    #   
    #   # The elements of +set+ must equal +int+
    #   set.elements.must == int
    #
    #   # The elements of +set+ must equal 17
    #   set.elements.must == 17
    def ==(operand, options = {})
      comparison(:==, operand, options)
    end

    # Constrains the set elements to be strictly greater than
    # +operand+ (either a constant integer or an integer operand).
    #
    # ==== Examples 
    #   
    #   # The elements of +set+ must be strictly greater than +int+
    #   set.elements.must > int
    #
    #   # The elements of +set+ must be strictly greater than 17
    #   set.elements.must > 17
    def >(operand, options = {})
      comparison(:>, operand, options)
    end
    
    # Constrains the set elements to be greater than or equal to
    # +operand+ (either a constant integer or an integer operand).
    #
    # ==== Examples 
    #   
    #   # The elements of +set+ must be greater than or equal to +int+
    #   set.elements.must >= int
    #
    #   # The elements of +set+ must be greater than or equal to 17
    #   set.elements.must >= 17
    def >=(operand, options = {})
      comparison(:>=, operand, options)
    end
    
    # Constrains the set elements to be strictly less than
    # +operand+ (either a constant integer or an integer operand).
    #
    # ==== Examples 
    #   
    #   # The elements of +set+ must be strictly less than +int+
    #   set.elements.must < int
    #
    #   # The elements of +set+ must be strictly less than 17
    #   set.elements.must < 17
    def <(operand, options = {})
      comparison(:<, operand, options)
    end
    
    # Constrains the set elements to be less than or equal to
    # +operand+ (either a constant integer or an integer operand).
    #
    # ==== Examples 
    #   
    #   # The elements of +set+ must be less than or equal to +int+
    #   set.elements.must <= int
    #
    #   # The elements of +set+ must be less than or equal to 17
    #   set.elements.must <= 17
    def <=(operand, options = {})
      comparison(:<=, operand, options)
    end
    
    alias_comparison_methods
    
    private

    # Helper for the comparison methods. The reason that they are not
    # generated in a loop is that it would mess up the RDoc.
    def comparison(name, operand, options)
      unless operand.respond_to?(:to_int_var) or 
          operand.kind_of?(Fixnum)
        raise TypeError, "Expected int operand or integer, got " + 
          "#{operand.class}."
      end
      unless options[:reify].nil?
        raise ArgumentError, 'Reification is not supported by the elements ' + 
          'relation constraint.'
      end

      unless @params[:negate]
        relation_type = Gecode::Util::RELATION_TYPES[name]
      else
        relation_type = Gecode::Util::NEGATED_RELATION_TYPES[name]
      end
      @params.update Gecode::Set::Util.decode_options(options)
      @model.add_constraint Relation::RelationConstraint.new(@model, 
        @params.update(:relation_type => relation_type, :rhs => operand))
    end
  end

  module Relation #:nodoc:
    class RelationConstraint < Gecode::Constraint #:nodoc:
      def post
        set_elements, rhs, type = @params.values_at(:lhs, :rhs, :relation_type)
        set = set_elements.to_set_elements
        
        if rhs.kind_of? Fixnum
          # Use a proxy int variable to cover.
          rhs = @model.int_var(rhs)
        end
        Gecode::Raw::rel(@model.active_space, set.to_set_var.bind, 
          type, rhs.to_int_var.bind)
      end
    end
  end
end
