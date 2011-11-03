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

require 'rust/class'

module Rust
  class CxxClass < Class
    # This function initializes the CxxClass instance by setting the
    # values to the attributes defining its parent, namespace, name
    # and a few other needed information.
    #
    # When a C++ Class is bound that is a child of another class, it
    # shares its highest anchestor's pointer map (as that is the
    # more general pointer type it can be referred to with), and
    # function to call when free()'ing.
    #
    # Don't call this function directly, use Namespace.add_cxx_class
    #
    # *FIXME*: multiple inheritance can make Rust bail out, badly.
    def initialize(name, namespace, parent = nil) # :notnew:
      super(name, namespace)
      @parent = parent

      @children_classes = []

      @definition_template = Templates["CxxClassDefinitions"]

      if @parent
        @ptrmap = @parent.ptrmap
        @function_free = @parent.function_free
        @parent_varname = "r#{@parent.varname}"
      else
        @declaration_template << Templates["StandaloneClassDeclarations"]
        @definition_template << Templates["CxxStandaloneClassDefinitions"]
      end

      add_expansion 'test_children'
    end
    
    def custom_extends(parent)
      @parent_varname = parent
    end

    # This function is used during ruby to C/C++ conversion of the
    # types, and test for the deepest class the pointer is valid for.
    def test_children
      return unless @children_classes
      
      ret = ""
      
      @children_classes.each do |klass|
        ret << %@
     if ( dynamic_cast< #{klass.namespace.cname}::#{klass.name}* >(instance) != NULL )
     {
       klass = c#{klass.varname};
       #{klass.test_children}
     }
     @
      end

      return ret
    end

    class Method < Class::Method
      def raw_call(nparam = nil)
        "tmp->#{super(nparam)}"
      end
    end

    class Constructor < Class::Constructor
      def raw_call(nparam = nil)
        "tmp = new #{@parent.namespace.cname}::#{super(nparam)}"
      end
    end

  end
end
