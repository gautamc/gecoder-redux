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

module Rust

  # C class wrapper class, this is used to provide support for those
  # wrappers around C libraries that are bound by Rust.
  class ClassWrapper < Class
    attr_reader :cleanup_functions

    def initialize(name, type, namespace) # :notnew:
      super(name, namespace)

      @cname = type
      @varcname = @cname.sub("*", "Ptr").gsub("::", "_").gsub(' ', '')
      @cleanup_functions = ""

      @definition_template = Templates["CWrapperClassDefinitions"]
      @declaration_template << Templates["StandaloneClassDeclarations"]

      add_expansion 'cleanup_functions', '@cleanup_functions'
    end

    def add_constructor(name)
      constructor = super()

      constructor.name = name

      return constructor
    end

    def add_cleanup_function(call)
      @cleanup_functions << call << "\n"
    end

    # This class is used to represente the constructor of a C++ class
    # bound in a Ruby extension.
    class Constructor < Class::Constructor
      attr_writer :name

      def raw_call(nparam = nil)
        "tmp = #{super(nparam)}"
      end
    end

    class Method < Class::Method
      def add_instance_parameter
        add_static_parameter 'tmp'
      end
    end
  end

end
