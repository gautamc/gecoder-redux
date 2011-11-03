module Gecode::Int
  module IntOperand
    # Produces a new IntOperand representing this operand plus 
    # +int_operand_or_fixnum+.
    #
    # ==== Examples 
    #
    #   # +int1+ plus +int2+
    #   int1 + int2
    #
    #   # +int+ plus 17
    #   int + 17
    def +(int_operand_or_fixnum)
      int_linear_expression_operation(:+, int_operand_or_fixnum)
    end
    
    # Produces a new IntOperand representing this operand minus 
    # +int_operand_or_fixnum+. 
    #
    # ==== Examples 
    #
    #   # +int1+ minus +int2+
    #   int1 - int2
    #
    #   # +int+ minus 17
    #   int - 17
    def -(int_operand_or_fixnum)
      int_linear_expression_operation(:-, int_operand_or_fixnum)
    end

    # Produces a new IntOperand representing this operand times a 
    # constant. 
    #
    # ==== Examples 
    #
    #   # +int+ times 17
    #   int * 17
    def *(fixnum)
      if fixnum.kind_of? Fixnum
        int_linear_expression_operation(:*, fixnum)
      else
        raise TypeError, "Expected fixnum, got #{fixnum.class}."
      end
    end

    private

    # Performs the int linear expression operation +operator+ on self
    # and +operand2+.
    def int_linear_expression_operation(operator, operand2)
      unless operand2.respond_to? :to_minimodel_lin_exp
        operand2 = Linear::ExpressionNode.new operand2
      end
      operand1 = self
      unless operand1.respond_to? :to_minimodel_lin_exp
        operand1 = Linear::ExpressionNode.new(self, @model)
      end
      Linear::ExpressionTree.new(operand1, operand2, operator)
    end
  end

  # A module that gathers the classes and modules used in linear constraints.
  module Linear #:nodoc:
    class LinearRelationConstraint < Gecode::ReifiableConstraint #:nodoc:
      def post
        lhs, rhs, relation_type, reif_var = 
          @params.values_at(:lhs, :rhs, :relation_type, :reif)
        reif_var = reif_var.to_bool_var.bind if reif_var.respond_to? :to_bool_var
        final_exp = (lhs.to_minimodel_lin_exp - rhs.to_minimodel_lin_exp)
        if reif_var.nil?
          final_exp.post(@model.active_space, relation_type, 
            *propagation_options)
        else
          final_exp.post(@model.active_space, relation_type, reif_var, 
            *propagation_options)
        end
      end
    end

    # Describes a binary tree of expression nodes which together form a linear 
    # expression.
    class ExpressionTree < Gecode::Int::ShortCircuitRelationsOperand #:nodoc:
      attr :model

      # Constructs a new expression with the specified operands.
      def initialize(left_node, right_node, operation)
        super(left_node.model || right_node.model)
        @left = left_node
        @right = right_node
        @operation = operation
        @model = @left.model || @right.model
      end
      
      # Converts the linear expression to an instance of 
      # Gecode::Raw::MiniModel::LinExpr
      def to_minimodel_lin_exp
        @left.to_minimodel_lin_exp.send(@operation, @right.to_minimodel_lin_exp)
      end

      def relation_constraint(relation, int_operand_or_fix, params)
        unless params[:negate]
          relation_type = 
            Gecode::Util::RELATION_TYPES[relation]
        else
          relation_type = 
            Gecode::Util::NEGATED_RELATION_TYPES[relation]
        end

        unless int_operand_or_fix.respond_to? :to_minimodel_lin_exp
          int_operand_or_fix = Linear::ExpressionNode.new(int_operand_or_fix);
        end

        params.update(:lhs => self, :rhs => int_operand_or_fix, 
          :relation_type => relation_type)
        LinearRelationConstraint.new(model, params)
      end
    end
    
    # Describes a single node in a linear expression.
    class ExpressionNode #:nodoc:
      attr :model
    
      def initialize(value, model = nil)
        unless value.respond_to?(:to_int_var) or value.kind_of?(Fixnum)
          raise TypeError, 'Expected int operand or fixnum, ' + 
            "got #{value.class}."
        end
        @value = value
        @model = model
      end
      
      # Converts the linear expression to an instance of 
      # Gecode::Raw::MiniModel::LinExpr
      def to_minimodel_lin_exp
        expression = @value
        if expression.respond_to? :to_int_var
          expression = expression.to_int_var.bind * 1
        end
        expression
      end
    end
  end
end
