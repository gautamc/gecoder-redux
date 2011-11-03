module Gecode::Bool
  module BoolLinearOperations #:nodoc:
    # Produces an IntOperand representing the value of this boolean
    # operand (0 or 1) plus +op2+.
    #
    # ==== Examples 
    #
    #   # +bool1+ plus +bool2+
    #   bool1 + bool2
    def +(op2)
      bool_linear_expression_operation(:+, op2)
    end
    
    # Produces an IntOperand representing the value of this boolean
    # operand (0 or 1) times a constant.
    #
    # ==== Examples 
    #
    #   # +bool+ times 17
    #   bool * 17
    def *(fixnum)
      if fixnum.kind_of? Fixnum
        bool_linear_expression_operation(:*, fixnum)
      else
        raise TypeError, "Expected fixnum, got #{fixnum.class}."
      end
    end
    
    # Produces an IntOperand representing the value of this boolean
    # operand (0 or 1) minus +op2+.
    #
    # ==== Examples 
    #
    #   # +bool1+ minus +bool2+
    #   bool1 - bool2
    def -(op2)
      bool_linear_expression_operation(:-, op2)
    end

    private

    # Performs the bool linear expression operation +operator+ on self
    # and +operand2+.
    def bool_linear_expression_operation(operator, operand2)
      linear_module = Linear
      unless operand2.respond_to? :to_minimodel_lin_exp
        operand2 = linear_module::ExpressionNode.new operand2
      end
      operand1 = self
      unless operand1.respond_to? :to_minimodel_lin_exp
        operand1 = linear_module::ExpressionNode.new(self, @model)
      end
      linear_module::ExpressionTree.new(operand1, operand2, operator)
    end
  end

  module BoolOperand
    # We include the operations and then redefine them so that they show
    # up in the documentation.
    include BoolLinearOperations

    # Produces an IntOperand representing the value of this boolean
    # operand (0 or 1) plus +op2+.
    #
    # ==== Examples 
    #
    #   # +bool1+ plus +bool2+
    #   bool1 + bool2
    def +(op2)
      bool_linear_expression_operation(:+, op2)
    end
    
    # Produces an IntOperand representing the value of this boolean
    # operand (0 or 1) times a constant.
    #
    # ==== Examples 
    #
    #   # +bool+ times 17
    #   bool * 17
    def *(fixnum)
      if fixnum.kind_of? Fixnum
        bool_linear_expression_operation(:*, fixnum)
      else
        raise TypeError, "Expected fixnum, got #{fixnum.class}."
      end
    end
    
    # Produces an IntOperand representing the value of this boolean
    # operand (0 or 1) minus +op2+.
    #
    # ==== Examples 
    #
    #   # +bool1+ minus +bool2+
    #   bool1 - bool2
    def -(op2)
      bool_linear_expression_operation(:-, op2)
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
      include Gecode::Bool::BoolLinearOperations
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

      alias_method :pre_bool_construct_receiver, :construct_receiver
      def construct_receiver(params)
        receiver = pre_bool_construct_receiver(params)
        lhs = self
        receiver.instance_eval{ @lhs = lhs }
        class <<receiver
          alias_method :pre_bool_equality, :==
          def ==(op, options = {})
            if op.respond_to? :to_bool_var
              (@lhs - op).must.equal(0, options)
            else
              pre_bool_equality(op, options)
            end
          end
          alias_comparison_methods
        end
        return receiver
      end

      def relation_constraint(relation, bool_operand_or_fix, params)
        unless params[:negate]
          relation_type = 
            Gecode::Util::RELATION_TYPES[relation]
        else
          relation_type = 
            Gecode::Util::NEGATED_RELATION_TYPES[relation]
        end

        unless bool_operand_or_fix.respond_to? :to_minimodel_lin_exp
          bool_operand_or_fix = Linear::ExpressionNode.new(bool_operand_or_fix);
        end

        params.update(:rhs => bool_operand_or_fix, :relation_type => relation_type)
        LinearRelationConstraint.new(model, params)
      end
    end
    
    # Describes a single node in a linear expression.
    class ExpressionNode #:nodoc:
      attr :model
    
      def initialize(value, model = nil)
        unless value.respond_to?(:to_bool_var) or value.kind_of?(Fixnum)
          raise TypeError, 'Expected bool operand or ' + 
            "fixnum, got #{value.class}."
        end
        @value = value
        @model = model
      end
      
      # Converts the linear expression to an instance of 
      # Gecode::Raw::MiniModel::LinExpr
      def to_minimodel_lin_exp
        expression = @value
        if expression.respond_to? :to_bool_var
          expression = expression.to_bool_var.bind * 1
        end
        expression
      end
    end
  end
end
