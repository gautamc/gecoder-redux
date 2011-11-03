module Gecode
  # Base class for all reifiable constraints.
  class ReifiableConstraint < Constraint #:nodoc:
    # Gets the reification operand of the constraint, nil if none exists.
    def reification_var
      @params[:reif]
    end
    
    # Sets the reification operand of the constraint, nil if none should be
    # used.
    def reification_var=(new_var)
      @params[:reif] = new_var
    end
    
    # Produces a disjunction of two reifiable constraints, producing a new
    # reifiable constraint.
    def |(constraint)
      with_reification_operands(constraint) do |b1, b2|
        # Create the disjunction constraint.
        (b1 | b2).must_be.true
      end
    end
    
    # Produces a conjunction of two reifiable constraints, producing a new
    # reifiable constraint.
    def &(constraint)
      with_reification_operands(constraint) do |b1, b2|
        # Create the conjunction constraint.
        (b1 & b2).must_be.true
      end
    end
    
    private
    
    # Yields two boolean operands to the specified block. The first one
    # is self's reification operand and the second one is the
    # reification operand of the specified constraint. Reuses
    # reification operands if possible, otherwise creates new ones.
    def with_reification_operands(constraint, &block)
      raise TypeError unless constraint.kind_of? ReifiableConstraint
      
      # Set up the reification operands, using existing operands if they 
      # exist.
      con1_holds = self.reification_var
      con2_holds = constraint.reification_var
      if con1_holds.nil?
        con1_holds = @model.bool_var
        self.reification_var = con1_holds
      end
      if con2_holds.nil?
        con2_holds = @model.bool_var
        constraint.reification_var = con2_holds
      end
      yield(con1_holds, con2_holds)
    end
    
    # If called the negation of the constraint will be handled using the 
    # reification operand. This means that the post method (which has to be 
    # defined prior to calling this method) doesn't have to bother about 
    # negation.
    def self.negate_using_reification
      class_eval do
        alias_method :post_without_negation, :post
        
        def post
          if @params[:negate]
            if @params[:reif].nil?
              # Create a reification variable if none exists.
              @params[:reif] = @model.bool_var
            end
            @params[:reif].must_be.false
          end
          post_without_negation
        end
      end
    end
  end
end
