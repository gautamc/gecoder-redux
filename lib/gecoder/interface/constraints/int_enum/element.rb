module Gecode::IntEnum
  module IntEnumOperand
    # This adds the adder for the methods in the modules including it. The 
    # reason for doing it so indirect is that the first #[] won't be defined 
    # before the module that this is mixed into is mixed into an enum.
    def self.included(enum_mod) #:nodoc:
      enum_mod.module_eval do
        # Now we enter the module IntEnumOperands is mixed into.
        class << self
          alias_method :pre_element_included, :included
          def included(mod) #:nodoc:
            mod.module_eval do
              if instance_methods.include? '[]'
                alias_method :pre_element_access, :[]
              end
          
              # Produces an IntOperand representing the
              # i:th integer operand in the enumeration, where i is the
              # value of the integer operand used as index. Think of it
              # as array access in the world of constraint programming.
              # 
              # ==== Examples 
              # 
              #   # The operand at the +x+:th position in +int_enum+,
              #   # where +x+ is an integer operand.  
              #   int_enum[x]
              # 
              def [](*vars)
                if vars.first.respond_to? :to_int_var
                  return Element::ElementIntOperand.new(
                    model, self, vars.first)
                else
                  pre_element_access(*vars) if respond_to? :pre_element_access
                end
              end
            end
            pre_element_included(mod)
          end
        end
      end
    end
  end

  module Element #:nodoc:
    class ElementIntOperand < Gecode::Int::ShortCircuitEqualityOperand #:nodoc:
      def initialize(model, enum_op, position_int_var_op)
        super model
        @enum = enum_op
        @position = position_int_var_op
      end

      def constrain_equal(int_operand, constrain, propagation_options)
        enum = @enum.to_int_enum
        if constrain
          int_operand.must_be.in enum.domain_range
        end

        Gecode::Raw::element(model.active_space, enum.bind_array, 
          @position.to_int_var.bind, int_operand.to_int_var.bind, 
          *propagation_options)
      end
    end
  end
end
