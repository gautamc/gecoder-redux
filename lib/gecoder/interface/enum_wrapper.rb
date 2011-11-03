module Gecode
  module Mixin
    # Wraps a custom enumerable so that constraints can be specified using it.
    # The argument is altered and returned. 
    def wrap_enum(enum)
      unless enum.kind_of? Enumerable
        raise TypeError, 'Only enumerables can be wrapped.'
      end
      if enum.kind_of? Gecode::EnumMethods
        raise ArgumentError, 'The enumration is already wrapped.'
      end
      elements = enum.to_a
      if elements.empty?
        raise ArgumentError, 'Enumerable must not be empty.'
      end
      
      if elements.all?{ |var| var.respond_to? :to_int_var }
        elements.map!{ |var| var.to_int_var }
        class <<enum
          include Gecode::IntEnumMethods
        end
      elsif elements.all?{ |var| var.respond_to? :to_bool_var }
        elements.map!{ |var| var.to_bool_var }
        class <<enum
          include Gecode::BoolEnumMethods
        end
      elsif elements.all?{ |var| var.respond_to? :to_set_var }
        elements.map!{ |var| var.to_set_var }
        class <<enum
          include Gecode::SetEnumMethods
        end
      elsif elements.all?{ |var| var.kind_of? Fixnum }
        class <<enum
          include Gecode::FixnumEnumMethods
        end
      else
        raise TypeError, "Enumerable doesn't contain operands #{enum.inspect}."
      end
      
      enum.model = self
      return enum
    end
  end
  
  # A module containing the methods needed by enumerations containing
  # operands.
  module EnumMethods #:nodoc:
    attr_accessor :model
    # Gets the current space of the model the array is connected to.
    def active_space
      @model.active_space
    end
  end
  
  module VariableEnumMethods #:nodoc:
    include EnumMethods
    
    # Gets the values of all the operands in the enum.
    def values
      map{ |var| var.value }
    end
  end
  
  # A module containing the methods needed by enumerations containing int 
  # operands. Requires that it's included in an enumerable.
  module IntEnumMethods #:nodoc:
    include IntEnum::IntEnumOperand
    include VariableEnumMethods
  
    # Returns an int variable array with all the bound variables.
    def bind_array
      space = @model.active_space
      unless @bound_space == space
        elements = to_a
        @bound_arr = Gecode::Raw::IntVarArray.new(active_space, elements.size)
        elements.each_with_index{ |var, index| @bound_arr[index] = var.bind }
        @bound_space = space
      end
      return @bound_arr
    end

    # Returns the receiver.
    def to_int_enum
      self
    end
    
    # Returns the smallest range that contains the domains of all integer 
    # variables involved.
    def domain_range
      inject(nil) do |range, var|
        min = var.min
        max = var.max
        next min..max if range.nil?
        
        range = min..range.last if min < range.first
        range = range.first..max if max > range.last
        range
      end
    end
  end

  # A dummy class that just shows what methods an int enum responds to.
  class IntEnum::Dummy < Array #:nodoc:
    include IntEnum::IntEnumOperand
    include VariableEnumMethods
  end
  
  # A module containing the methods needed by enumerations containing boolean
  # operands. Requires that it's included in an enumerable.
  module BoolEnumMethods #:nodoc:
    include BoolEnum::BoolEnumOperand
    include VariableEnumMethods
  
    # Returns a bool variable array with all the bound variables.
    def bind_array
      space = @model.active_space
      unless @bound_space == space
        elements = to_a
        @bound_arr = Gecode::Raw::BoolVarArray.new(active_space, elements.size)
        elements.each_with_index{ |var, index| @bound_arr[index] = var.bind }
        @bound_space = space
      end
      return @bound_arr
    end

    # Returns the receiver.
    def to_bool_enum
      self
    end
  end

  # A dummy class that just shows what methods a bool enum responds to.
  class BoolEnum::Dummy < Array #:nodoc:
    include BoolEnum::BoolEnumOperand
    include VariableEnumMethods
  end
  
  # A module containing the methods needed by enumerations containing set
  # operands. Requires that it's included in an enumerable.
  module SetEnumMethods #:nodoc:
    include SetEnum::SetEnumOperand
    include VariableEnumMethods
  
    # Returns a set variable array with all the bound variables.
    def bind_array
      space = @model.active_space
      unless @bound_space == space
        elements = to_a
        @bound_arr = Gecode::Raw::SetVarArray.new(active_space, elements.size)
        elements.each_with_index{ |var, index| @bound_arr[index] = var.bind }
        @bound_space = space
      end
      return @bound_arr
    end
    
    # Returns the receiver.
    def to_set_enum
      self
    end

    # Returns the range of the union of the contained sets' upper bounds.
    def upper_bound_range
      inject(nil) do |range, var|
        upper_bound = var.upper_bound
        min = upper_bound.min
        max = upper_bound.max
        next min..max if range.nil?
        
        range = min..range.last if min < range.first
        range = range.first..max if max > range.last
        range
      end
    end
  end

  # A dummy class that just shows what methods a set enum responds to.
  class SetEnum::Dummy < Array #:nodoc:
    include SetEnum::SetEnumOperand
    include VariableEnumMethods
  end
  
  # A module containing the methods needed by enumerations containing fixnums. 
  # Requires that it's included in an enumerable.
  module FixnumEnumMethods #:nodoc:
    include FixnumEnum::FixnumEnumOperand
    include EnumMethods
    
    # Returns the receiver.
    def to_fixnum_enum
      self
    end

    # Returns the smallest range that contains the domains of all integer 
    # variables involved.
    def domain_range
      min..max
    end
  end
  
  # A dummy class that just shows what methods a fixnum enum responds to.
  class FixnumEnum::Dummy < Array #:nodoc:
    include FixnumEnum::FixnumEnumOperand
    include VariableEnumMethods
  end
end
