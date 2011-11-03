# A module containing constraints that have set_enum[set] as left hand
# side.
module Gecode::SelectedSet #:nodoc:
  # A SelectedSetOperand is an uncommon operand that results from calling 
  # SetEnumOperand#[] with a SetOperand. It facilitates placing the 
  # constraints defined in SelectedSetConstraintReceiver
  #
  # ==== Examples 
  #
  # Producing a SelectedSetOperand from +set_enum+ and +set_operand+:
  #
  #   set_enum[set_operand]
  #
  class SelectedSetOperand
    include Gecode::Operand 

    # Constructs a new selected set operand from +set_enum+ and +set+.
    def initialize(set_enum, set) #:nodoc:
      unless set_enum.respond_to? :to_set_enum
        raise TypeError, "Expected set enum operand, got #{set_enum.class}."
      end
      unless set.respond_to? :to_set_var
        raise TypeError, "Expected set operand, got #{set.class}."
      end

      @set_enum = set_enum
      @set = set
    end

    # Returns the set enum and set that make up the selected set
    # operand.
    def to_selected_set #:nodoc:
      return @set_enum, @set
    end

    def model #:nodoc:
      @set_enum.model
    end

    private

    def construct_receiver(params)
      SelectedSetConstraintReceiver.new(model, params)
    end
  end

  # SelectedSetConstraintReceiver contains all constraints that can be
  # placed on a SelectedSetOperand.
  #
  # Constraints are placed by calling SelectedSetOperand#must (or any other
  # of the variations defined in Operand), which produces a 
  # SelectedSetConstraintReceiver from which the desired constraint can 
  # be used.
  #
  # ==== Examples 
  #
  # Constrains the sets in +set_enum+ that are selected by +set_operand+ to be
  # disjoint. This uses SetEnumOperand#[] and
  # SelectedSetConstraintReceiver#disjoint. 
  #
  #   set_enum[set_operand].must_be.disjoint
  #
  class SelectedSetConstraintReceiver < Gecode::ConstraintReceiver
    # Raises TypeError unless the left hand side is a selected set operand.
    def initialize(model, params) #:nodoc:
      super

      unless params[:lhs].respond_to? :to_selected_set
        raise TypeError, 'Must have selected set operand as left hand side.'
      end
    end
  end
end

require 'gecoder/interface/constraints/selected_set/select'
