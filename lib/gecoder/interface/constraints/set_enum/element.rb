module Gecode::SetEnum
  module SetEnumOperand
    # This adds the adder for the methods in the modules including it. The 
    # reason for doing it so indirect is that the first #[] won't be defined 
    # before the module that this is mixed into is mixed into an enum.
    def self.included(mod) #:nodoc:
      mod.module_eval do
        # Now we enter the module SetEnumOperands is mixed into.
        class << self
          alias_method :pre_set_element_included, :included
          def included(mod) #:nodoc:
            mod.module_eval do
              # Now we enter the module that the module possibly defining #[] 
              # is mixed into.
              if instance_methods.include?('[]') and 
                  not instance_methods.include?('pre_set_element_access')
                alias_method :pre_set_element_access, :[]
              end
            
              # Produces a SetOperand representing the i:th set
              # operand in the enumeration, where i is the value of the
              # int operand used as index. 
              #
              # A set can also be used as index, in which case a
              # SelectedSetOperand is produced.
              #
              # ==== Examples 
              # 
              #   # The set operand at the +x+:th position in +set_enum+,
              #   # where +x+ is a int operand.  
              #   set_enum[x]
              #
              #   # The SelectedSetOperand representing sets at positions
              #   # included in the value of +set+ in +set_enum+,
              #   set_enum[set]
              #
              def [](*vars)
                # Hook in an element constraint if a operand is used for array 
                # access.
                if vars.first.respond_to? :to_int_var
                  Element::ElementSetOperand.new(
                    model, self, vars.first)
                elsif vars.first.respond_to? :to_set_var
                  Gecode::SelectedSet::SelectedSetOperand.new(
                    self, vars.first)
                else
                  if respond_to? :pre_set_element_access
                    pre_set_element_access(*vars) 
                  end
                end
              end
            end
            pre_set_element_included(mod)
          end
        end
      end
    end
  end

  module Element #:nodoc:
    class ElementSetOperand < Gecode::Set::ShortCircuitEqualityOperand #:nodoc:
      def initialize(model, enum_op, position_int_op)
        super model
        @enum = enum_op
        @position = position_int_op
      end

      def constrain_equal(set_operand, constrain, propagation_options)
        enum = @enum.to_set_enum
        if constrain
          set_operand.must_be.subset_of enum.upper_bound_range
        end

        Gecode::Raw::element(@model.active_space, enum.bind_array, 
          @position.to_int_var.bind, set_operand.to_set_var.bind)
      end
    end
  end 
end
