# A module that deals with the operands, properties and constraints of
# integer variables.
module Gecode::Int #:nodoc:
  # A IntOperand is a combination of variables on which the
  # constraints defined in IntConstraintReceiver can be placed.
  #
  # Integer operands can be created either by using
  # Gecode::Mixin#int_var et al, or by using properties that produce
  # integer operands. The operands, no matter how they were created, 
  # all respond to the properties defined by IntOperand.
  #
  # ==== Examples 
  #
  # Produces a single integer operand (more specifically an IntVar) with
  # domain 0..9 inside a problem formulation, using
  # Gecode::Mixin#int_var:
  #
  #   int_operand = int_var(0..9)
  #
  # Uses the IntOperand#+ property to produce a new integer
  # operand representing +int_operand1+ plus +int_operand2+:
  #
  #   new_int_operand = int_operand1 + int_operand2
  #
  # Uses the IntEnumOperand#max property to produce a new
  # integer operand representing the maximum value of the integer operands
  # in the enumeration +int_enum+:
  # 
  #   new_int_operand = int_enum.max
  #
  # Uses the IntEnumOperand#[] property to produce a new integer operand
  # representing the integer operand at the index decided by
  # +int_operand+ (which can change during search) in the enumeration
  # +int_enum+:
  # 
  #   new_int_operand = int_enum[int_operand]
  #
  # Uses the SetOperand#size property to produce a new integer operand
  # representing the size of +set_operand+:
  #
  #   new_int_operand = set_operand.size
  #
  #--
  # Classes that mix in IntOperand must define #model and #to_int_var .
  module IntOperand  
    include Gecode::Operand 

    def method_missing(method, *args) #:nodoc:
      if Gecode::IntVar.instance_methods.include? method.to_s
        # Delegate to the int var.
        to_int_var.method(method).call(*args)
      else
        super
      end
    end

    private

    def construct_receiver(params)
      IntConstraintReceiver.new(model, params)
    end
  end

  # An operand that short circuits integer equality.
  class ShortCircuitEqualityOperand #:nodoc:
    include Gecode::Int::IntOperand
    attr :model

    def initialize(model)
      @model = model
    end

    def construct_receiver(params)
      params.update(:lhs => self)
      receiver = IntConstraintReceiver.new(@model, params)
      op = self
      receiver.instance_eval{ @short_circuit = op }
      class <<receiver
        alias_method :equality_without_short_circuit, :==
        def ==(operand, options = {})
          if !@params[:negate] and options[:reify].nil? and 
              operand.respond_to? :to_int_var
            # Short circuit the constraint.
            @params.update Gecode::Util.decode_options(options)
            @model.add_constraint(Gecode::BlockConstraint.new(
                @model, @params) do
              @short_circuit.constrain_equal(operand, false,
                @params.values_at(:strength, :kind))
            end)
          else
            equality_without_short_circuit(operand, options)
          end
        end
        alias_comparison_methods
      end

      return receiver
    end

    def to_int_var
      variable = model.int_var
      options = 
        Gecode::Util.decode_options({}).values_at(:strength, :kind)
      model.add_interaction do
        constrain_equal(variable, true, options)
      end
      return variable
    end

    private

    # Constrains this operand to equal +int_operand+ using the
    # specified +propagation_options+. If +constrain_domain+ is true
    # then the method should also attempt to constrain the bounds of the
    # domain of +int_operand+.
    def constrain_equal(int_operand, constrain_domain, propagation_options)
      raise NotImplementedError, 'Abstract method has not been implemented.'
    end
  end

  # An operand that short circuits integer relation constraints.
  class ShortCircuitRelationsOperand #:nodoc:
    include Gecode::Int::IntOperand
    attr :model

    def initialize(model)
      @model = model
    end

    def construct_receiver(params)
      receiver = IntConstraintReceiver.new(@model, params)
      op = self
      receiver.instance_eval{ @short_circuit = op }
      class <<receiver
        Gecode::Util::COMPARISON_ALIASES.keys.each_with_index do |comp, i|
          eval <<-end_code
            alias_method :alias_#{i}_without_short_circuit, :#{comp}
            def #{comp}(operand, options = {})
              if operand.respond_to?(:to_int_var) or operand.kind_of? Fixnum
                # Short circuit the constraint.
                @params.update Gecode::Util.decode_options(options)
                @model.add_constraint(
                  @short_circuit.relation_constraint(
                    :#{comp}, operand, @params))
              else
                alias_#{i}_without_short_circuit(operand, options)
              end
            end
          end_code
        end
        alias_comparison_methods
      end

      return receiver
    end

    def to_int_var
      variable = model.int_var
      params = {}
      params.update Gecode::Util.decode_options({})
      model.add_constraint relation_constraint(:==, variable, params)
      return variable
    end

    # Returns a constraint that constrains this operand to have relation
    # +relation+ to +int_operand_or_fix+, which is either an integer 
    # operand or a fixnum, given the specified hash +params+ of parameters.
    def relation_constraint(relation, int_operand_or_fix, params)
      raise NotImplementedError, 'Abstract method has not been implemented.'
    end
  end

  # IntConstraintReceiver contains all constraints that can be
  # placed on an IntOperand.
  #
  # Constraints are placed by calling IntOperand#must (or any other
  # of the variations defined in Operand), which produces a 
  # IntConstraintReceiver from which the desired constraint can be used.
  #
  # Each constraint accepts a number of options. See ConstraintReceiver
  # for more information.
  #
  # ==== Examples 
  #
  # Constrains +int_operand+ to be strictly greater than 5 using
  # IntConstraintReceiver#>:
  #
  #   int_operand.must > 5
  #
  # Constrains +int_operand1+ plus +int_operand2+ to be strictly 
  # greater than 5 using the IntOperand#+ property and 
  # IntConstraintReceiver#>:
  #
  #   (int_operand1 + int_operand2).must > 5
  #
  # Constrains the maximum value of the integer operands in +int_enum+ to
  # _not_ be in the range 3..7 using the IntEnumOperand#max property and 
  # IntConstraintReceiver#in:
  #
  #   int_enum.max.must_not_be.in 3..7
  #
  # Constrains the integer operand at position +int_operand+ in
  # +int_enum+, an enumeration of integer operands, to be greater than
  # or equal to +int_operand2+. This uses the IntEnumOperand#[] property 
  # and IntConstraintReceiver#>=:
  #
  #   int_enum[int_operand].must >= int_operand2
  #
  # The same as above, but specifying that strength :domain should be 
  # used and that the constraint should be reified with +bool_operand+:
  #
  #   int_enum[int_operand].must_be.greater_or_equal(int_operand2, :strength => :domain, :reify => bool_operand)
  #
  class IntConstraintReceiver < Gecode::ConstraintReceiver
    # Raises TypeError unless the left hand side is an int operand.
    def initialize(model, params) #:nodoc:
      super

      unless params[:lhs].respond_to? :to_int_var
        raise TypeError, 'Must have int operand as left hand side.'
      end
    end
  end
end

require 'gecoder/interface/constraints/int/relation'
require 'gecoder/interface/constraints/int/linear'
require 'gecoder/interface/constraints/int/domain'
require 'gecoder/interface/constraints/int/arithmetic'
require 'gecoder/interface/constraints/int/channel'
