# A module containing constraints that have set.elements as left hand
# side.
module Gecode::SetElements #:nodoc:
  # A SetElementsOperand is an uncommon operand that results from calling 
  # SetOperand#elements. It facilitates placing the constraints defined
  # in SetElementsConstraintReceiver
  #
  # ==== Examples 
  #
  # Producing a SetElementsOperand from +set_operand+:
  #
  #   set_operand.elements
  #
  class SetElementsOperand 
    include Gecode::Operand 

    # Constructs a new set elements operand +set+.
    def initialize(set) #:nodoc:
      unless set.respond_to? :to_set_var
        raise TypeError, "Expected set operand, got #{set.class}."
      end

      @set = set
    end

    # Returns the set operand that makes up the set elements operand.
    def to_set_elements #:nodoc:
      return @set
    end

    def model #:nodoc:
      @set.model
    end

    private

    def construct_receiver(params)
      SetElementsConstraintReceiver.new(model, params)
    end
  end

  # SetElementsConstraintReceiver contains all constraints that can be
  # placed on a SetElementsOperand.
  #
  # Constraints are placed by calling SetElementsOperand#must (or any other
  # of the variations defined in Operand), which produces a 
  # SetElementsConstraintReceiver from which the desired constraint can 
  # be used.
  #
  # Each constraint accepts a number of options. See ConstraintReceiver
  # for more information.
  #
  # ==== Examples 
  #
  # Constrains all elements in +set_operand+ to be strictly greater than 17
  # using SetOperand#elements and SetElementsConstraintReceiver#>: 
  #
  #   set.elements.must > 17
  #
  # Constrains all elements in +set_operand+ to be strictly greater than
  # +int_operand+ using SetOperand#elements and SetElementsConstraintReceiver#>:
  #
  #   set.elements.must > int_operand
  #
  # The same as above, but specifying that strength :domain should be 
  # used and that the constraint should be reified with +bool_operand+:
  #
  #   set.elements.must_be.greater_than(int_operand, :strength => :domain, :reify => bool_operand)
  #
  class SetElementsConstraintReceiver < Gecode::ConstraintReceiver
    # Raises TypeError unless the left hand side is set elements operand.
    def initialize(model, params) #:nodoc:
      super

      unless params[:lhs].respond_to? :to_set_elements
        raise TypeError, 'Must have set elements operand as left hand side.'
      end
    end
  end
end

module Gecode::Set #:nodoc:
  module SetOperand
    # Produces a SetElementsOperand on which relation constraints can be placed that
    # constrain all elements in the set.
    #
    # ==== Examples 
    #
    #   # The elements of +set+.
    #   set.elements
    def elements
      Gecode::SetElements::SetElementsOperand.new(self)
    end
  end
end

require 'gecoder/interface/constraints/set_elements/relation.rb'
