# Copyright (c) 2005-2007 Diego Pettenò <flameeyes@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE
# FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'rust/container'
require 'rust/function'
require 'rust/attribute'
require 'rust/type'

module Rust
  class Class < Container
    attr_accessor :bindname
    attr_accessor :function_mark
    attr_reader :name, :cname
    attr_reader :varname, :varcname, :ptrmap, :function_free, :function_map_free, :parent_varname

    # Rust::Namespace object for the class, used to get the proper C++
    # name.
    attr_reader :namespace

    # This function initializes the Class instance by setting the
    # values to the attributes defining its namespace, name
    # and a few other needed information.
    #
    # Don't call this function directly, use Namespace.add_cxx_class
    def initialize(name, namespace, bindname = name.gsub(/::([^<>]+)$/,'\1') ) # :notnew:
      super()
      
      @name = name
      @namespace = namespace
      
      type = Type.new(complete_name)
      @varname = type.valid_name
      @parent_varname = "rb_cObject"
      
      @ptrmap = "#{type.valid_name}Map"
      @function_free = "#{varname}_free"
      @function_map_free = "#{varname}_free_map_entry"
      @function_mark = "#{varname}_mark"

      @cname = @namespace.cname ? "#{@namespace.cname}::#{@name}" : @name
      
      type = Type.new(@cname)
      @varcname = type.valid_name
      @bindname = bindname

      @declaration_template = Templates["ClassDeclarations"]
      @initialization_template = Templates["ClassInitialize"]

      add_expansion 'class_varname', 'varname'
      add_expansion 'class_varcname', 'varcname'
      add_expansion 'c_class_name', 'cname'
#       add_expansion 'c_class_basename', '@name.split("::").last'
      add_expansion 'bind_name', '@bindname'
      add_expansion 'class_ptrmap', 'ptrmap'
      add_expansion 'class_free_function', '@function_free'
      add_expansion 'class_map_free_function', '@function_map_free'
      add_expansion 'class_mark_function', '@function_mark'
      add_expansion 'parent_varname', '@parent_varname'
    end

    # Adds a new constructor for the class.
    # This function creates a new constructor method for the C/C++
    # class to bind, and yields it so that parameters can be added
    # afterward.
    def add_constructor
      constructor = self.class::Constructor.new(self)

      begin
        yield constructor
      rescue LocalJumpError
        # Ignore this, we can easily have methods without parameters
        # or other extra informations.
      end if block_given?

      register_function(constructor)

      return constructor
    end

    # Adds a new method for the class.
    # This function adds a new generic method for the class. In the
    # case of C++ classes, this is an actual method of the bound
    # class, while in case of Class Wrappers, this is just a function
    # that expects to find a static parameter that is the instance
    # pointer itself.
    def add_method(name, return_value = "void", bindname = name)
      method = self.class::Method.new({ :name => name,
                            :bindname => bindname,
                            :return => return_value,
                            :klass => self
                          })

      begin
        yield method
      rescue LocalJumpError
        # Ignore this, we can easily have methods without parameters
        # or other extra informations.
      end if block_given?
      
      register_function(method)

      method
    end
    
    def add_attribute(name, type, bindname = name)
      attribute = Attribute.new(name, type, { :parent => self })
      
      yield attribute if block_given?
      
      @children << attribute
      
      attribute
    end
    
    def add_operator(name, return_value, bindname = name)
      operator = Class::Operator.new({ :name => name,
                            :bindname => bindname,
                            :return => return_value,
                            :klass => self
                          })
      begin
        yield operator
      rescue LocalJumpError
      end if block_given?
      
      register_function(operator)
      
      
      return operator
    end
    
    def complete_name
        name = @name
        parent = @parent
        namespace = @namespace
        
        if not parent.nil?
          name = "#{parent.cname}::#{name}"
        end
        
        if not namespace.nil?
          name = "#{namespace.cname}::#{name}"
        end
        
        return name if parent.nil?
        
        while not parent.parent.nil?
          name = "#{parent.parent.cname}::#{name}"
          parent = parent.parent
        end
        
        return name if namespace.nil?
        
        while not namespace.parent.nil?
          name = "#{namespace.parent.cname}::#{name}"
          namespace = namespace.parent
        end
        
        name
      end

    # Adds a new variable for the class. It's not an actual variable,
    # as hopefully there aren't global or class public variables in
    # any library.
    # These virtual variables have setter and getter methods, usually
    # called 'var' and 'setVar' in C++ (or 'getVar' and 'setVar'), and
    # are mapped to 'var' and 'var=' in Ruby, so that setting the
    # variable in Ruby will just call the setter method.
    def add_variable(name, type, getter = nil, setter = nil)
      getter = name unless getter
      setter = "set" + name[0..0].capitalize + name[1..-1] unless
        setter

      method_get = add_method getter, type
      method_get.add_alias name

      method_set = add_method setter, "void"
      method_set.add_alias "#{name}="

      begin
        yield method_get, method_set
      rescue LocalJumpError
        # Ignore this, we can easily have methods without parameters
        # or other extra informations.
      end if block_given?

      method_set.add_parameter type, "value"

      return [method_get, method_set]
    end

    # This class is used to represent a method for a C/C++ class bound
    # in a Ruby extension. Through an object of this class you can add
    # parameters and more to the method.
    class Method < Function
      
      # Initialisation function, calls Function.initialize and sets
      # the important parameters that differs from a generic function
      def initialize(params) # :notnew:
        params[:parent] = params[:klass]
        super

        @varname =
        "f#{@parent.namespace.name.gsub("::","_")}_#{@parent.varname}_#{@name}"

        @definition_template = Templates["CxxMethodStub"]
        @initialization_template = Templates["MethodInitBinding"]
      end
    end
    
    class Operator < Function
      attr_reader :position # 1: pre 2: mid 3: post 4: mixed
      
      def initialize(params)
        params[:parent] = params[:klass]
        super
        
        type = Type.new(@parent.namespace.cname+"::"+@parent.cname)
        
        @varname = "f#{type.valid_name}_#{valid_name}"
        
        @definition_template = Templates["CxxMethodStub"]
        @initialization_template = Templates["MethodInitBinding"]
      end
      
      def bind_call(nparam = nil)
        case @return
          when nil
            raise "nil return value is not supported for non-constructors."
          when "void"
            return "#{raw_call(nparam)}; return Qnil;\n"
          else
            type = Type.new(@return)
            if not @return.include?("*") and not type.native?
              "return cxx2ruby( new #{@return.gsub("&", "")}(#{raw_call(nparam)}), true );\n" # XXX: needs a copy constructor
            else
              "return cxx2ruby( static_cast<#{@return}>(#{raw_call(nparam)}) );\n"
            end
        end
      end
      
      private
      def raw_call(nparam = nil)
        case position(@parameters.size)
          when 1 # pre
            "#{@name} (*tmp)"
          when 2 # mid
            "(*tmp) #{@name[0].chr} #{params_conversion(nparam)} #{@name[@name.length-1].chr} "
          when 4
            "(*tmp) #{@name[0].chr} #{self.parameters[0].conversion} #{@name[1].chr} #{@name[@name.length-1].chr} #{self.parameters[1].conversion}" if self.parameters.size == 2
          else
            "(*tmp) #{@name} #{params_conversion(nparam)} "
        end
      end
      
      # 1: pre 2: mid 3: post 4: mixed
      def position(nparam)
        case @name
          when "+" 
            (nparam.zero? ? 1 : 3)
          when "-" 
            3
          when "*" 
            (nparam.zero? ? 1 : 3)
          when "/" 
            3
          when /\[\s*\]=/ 
            4
          when /\[\s*\]/ 
            2
          when "==" 
            3
          when "!=" 
            3
          when "<<" 
            3
          when ">>" 
            3
          when "!" 
            1
          when "()" 
            2
          else
            3
        end
      end
      
      def valid_name
        case @name
          when "+" 
            "plusop"
          when "-" 
            "minusop"
          when "*" 
            "multop"
          when "/" 
            "divop"
          when /\[\s*\]=/ 
            "ateqop"
          when /\[\s*\]/ 
            "atop"
          when "==" 
            "equalop"
          when "!=" 
            "notequalop"
          when "<<" 
            "outstream"
          when ">>" 
            "intstream"
          when "!" 
            "notop"
          when "()" 
            "parenthesisop"
          else
            "undefop_#{@name[0].chr.to_i}#{rand(1024)}"
        end
      end
    end

    # This class is used to represente the constructor of a C++ class
    # bound in a Ruby extension.
    class Constructor < Function
      
      # Initialisation function, calls Function.initialise, but accepts
      # only a single parameter, the class the constructor belong to.
      def initialize(klass) # :notnew:
        super({
                :parent => klass,
                :bindname => "initialize",
                :name => klass.name
              })

        @definition_template = Templates["ConstructorStub"]
      end

      def bind_call(nparam = nil)
        "#{raw_call(nparam)};\n"
      end
    end

  end
end
