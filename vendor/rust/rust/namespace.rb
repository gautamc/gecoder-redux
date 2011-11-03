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

require "rust/container"
require "rust/cxxclass"
require "rust/cwrapper"
require "rust/constants"

module Rust

  class Namespace < Container
    attr_reader :name, :cname, :varname

    def initialize(name, cname, parent = nil)
      super()

      @name = name
      
      if parent.kind_of?(Namespace)
        cname = "#{parent.cname}::#{cname}"
      end
      
      @parent = parent
      @cname = cname == "" ? nil : cname
      @varname = "#{@name.gsub("::", "_")}"

      @declaration_template = Templates["ModuleDeclarations"]
      @definition_template = Templates["ModuleDefinitions"]
      unless parent.kind_of?(Namespace)
	  @initialization_template = "r!namespace_varname! = rb_define_module(\"!module_name!\");\n"
      else
        # TODO this should use the expansion
        @initialization_template = "r!namespace_varname! = rb_define_module_under(r#{parent.varname}, \"#{@name}\");\n"
      end

      add_expansion 'module_name', 'name'
      add_expansion 'namespace_varname', 'varname'
    end

  end

end
