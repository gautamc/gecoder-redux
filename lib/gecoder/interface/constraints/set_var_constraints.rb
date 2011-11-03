# A module containing constraints that have set operands as left hand side
# (but not enumerations).
module Gecode::Set #:nodoc:
  # A SetOperand is a combination of operands on which the
  # constraints defined in SetConstraintReceiver can be placed.
  #
  # Set operands can be created either by using Gecode::Mixin#set_var et
  # al, or by using properties that produce set operands. The operands,
  # no matter how they were created, all respond to the properties
  # defined by SetOperand.
  #
  # ==== Examples 
  #
  # Produces a single set operand (more specifically a SetVar), with
  # greatest lower bound {0} and least upper bound {0, 1, 2}, inside a
  # problem formulation, using Gecode::Mixin#set_var:
  #
  #   set_operand = set_var(0, 0..2)
  #
  # Uses the SetOperand#union property to produce a new set operand
  # representing the union between +set_operand1+ and +set_operand2+: 
  #
  #   new_set_operand = set_operand1.union(set_operand2)
  #
  # Uses the SetEnumOperand#union property to produce a new set operand
  # representing the union of the set operands in the enumeration
  # +set_enum+:
  # 
  #   new_set_operand = set_enum.union
  #
  # Uses the SetEnumOperand#[] property to produce a new set operand
  # representing the set operand at the index decided by
  # +int_operand+ (which can change during search) in the enumeration
  # +set_enum+:
  # 
  #   new_set_operand = set_enum[int_operand]
  #
  #--
  # Classes that mix in SetOperand must define #model and #to_set_var .
  module SetOperand  
    include Gecode::Operand 

    def method_missing(method, *args) #:nodoc:
      if Gecode::SetVar.instance_methods.include? method.to_s
        # Delegate to the set var.
        to_set_var.method(method).call(*args)
      else
        super
      end
    end

    private

    def construct_receiver(params)
      SetConstraintReceiver.new(model, params)
    end
  end

  # An operand that short circuits set equality.
  class ShortCircuitEqualityOperand #:nodoc:
    include Gecode::Set::SetOperand
    attr :model

    def initialize(model)
      @model = model
    end

    def construct_receiver(params)
      params.update(:lhs => self)
      receiver = SetConstraintReceiver.new(@model, params)
      op = self
      receiver.instance_eval{ @short_circuit = op }
      class <<receiver
        alias_method :equality_without_short_circuit, :==
        def ==(operand, options = {})
          if !@params[:negate] and !options.has_key?(:reify) and 
              operand.respond_to? :to_set_var
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

    def to_set_var
      variable = model.set_var
      options = 
        Gecode::Set::Util.decode_options(
          {}).values_at(:strength, :kind)
      model.add_interaction do
        constrain_equal(variable, true, options)
      end
      return variable
    end

    private

    # Constrains this operand to equal +set_operand+ using the
    # specified +propagation_options+. If +constrain_domain+ is true
    # then the method should also attempt to constrain the bounds of the
    # domain of +set_operand+.
    def constrain_equal(set_operand, constrain_domain, propagation_options)
      raise NotImplementedError, 'Abstract method has not been implemented.'
    end
  end

  # An operand that short circuits set non-negated and non-reified versions 
  # of the relation constraints.
  class ShortCircuitRelationsOperand #:nodoc:
    include Gecode::Set::SetOperand
    attr :model

    def initialize(model)
      @model = model
    end

    def construct_receiver(params)
      params.update(:lhs => self)
      receiver = SetConstraintReceiver.new(@model, params)
      op = self
      receiver.instance_eval{ @short_circuit = op }
      class <<receiver
        Gecode::Util::SET_RELATION_TYPES.keys.each_with_index do |comp, i|
          eval <<-end_code
            alias_method :alias_#{i}_without_short_circuit, :#{comp}
            def #{comp}(operand, options = {})
              if !@params[:negate] && !options.has_key?(:reify) && 
                  (operand.respond_to?(:to_set_var) or 
                  Gecode::Util::constant_set?(operand))
                # Short circuit the constraint.
                @params.update Gecode::Set::Util.decode_options(options)
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

    def to_set_var
      variable = model.set_var
      params = {:lhs => self}
      params.update Gecode::Set::Util.decode_options({})
      model.add_constraint relation_constraint(:==, variable, params)
      return variable
    end

    # Returns a constraint that constrains this operand to have relation
    # +relation+ to +set_operand_or_constant_set+, which is either a set
    # operand or a constant set, given the specified hash +params+ of 
    # parameters. The constraints are never negated nor reified.
    def relation_constraint(relation, set_operand_or_constant_set, params)
      raise NotImplementedError, 'Abstract method has not been implemented.'
    end
  end

  # SetConstraintReceiver contains all constraints that can be
  # placed on a SetOperand.
  #
  # Constraints are placed by calling SetOperand#must (or any other
  # of the variations defined in Operand), which produces a 
  # SetConstraintReceiver from which the desired constraint can be used.
  #
  # Most constraint accept :reify option. See ConstraintReceiver for
  # more information.
  #
  # ==== Examples 
  #
  # Constrains +set_operand+ to be a subset of {0, 1, 2} using
  # an alias of SetConstraintReceiver#subset:
  #
  #   set_operand.must_be.subset_of 0..2
  #
  # Constrains the union of +set_operand1+ and +set_operand2+ to a
  # subset of {0, 1, 2} using the SetOperand#union property and
  # SetConstraintReceiver#subset:
  #
  #   set_operand1.union(set_operand2).must_be.subset_of 0..2
  #
  # Constrains the union of the set operands in +set_enum+ to _not_ 
  # equal {0, 1, 2} by using the SetEnumOperand#union property and 
  # an alias of SetConstraintReceiver#==:
  #
  #   set_enum.union.must_not == 0..2
  #
  # The same as above, but alsa specifying that the constraint should be 
  # reified with +bool_operand+:
  #
  #   set_enum.union.must_not.equal(0..2, :reify => bool_operand)
  #
  class SetConstraintReceiver < Gecode::ConstraintReceiver
    # Raises TypeError unless the left hand side is a set operand.
    def initialize(model, params) #:nodoc:
      super

      unless params[:lhs].respond_to? :to_set_var
        raise TypeError, 'Must have set operand as left hand side.'
      end
    end
  end

  # Utility methods for sets.
  module Util #:nodoc:
    module_function
    def decode_options(options)
      if options.has_key? :strength
        raise ArgumentError, 'Set constraints do not support the strength ' +
          'option.'
      end
      if options.has_key? :kind
        raise ArgumentError, 'Set constraints do not support the kind ' +
          'option.'
      end
      
      Gecode::Util.decode_options(options)
    end
  end
end

require 'gecoder/interface/constraints/set/domain'
require 'gecoder/interface/constraints/set/relation'
require 'gecoder/interface/constraints/set/cardinality'
require 'gecoder/interface/constraints/set/connection'
require 'gecoder/interface/constraints/set/include'
require 'gecoder/interface/constraints/set/operation'
require 'gecoder/interface/constraints/set/channel'
