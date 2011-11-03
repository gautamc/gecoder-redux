# Copyright (c) 2007 Diego Pettenò <flameeyes@gmail.com>
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
  # This class represent an enumeration type. The only reason to bind
  # an enumeration in Ruby with something more than than an integer
  # conversion is so that you can actually validate the parameter
  # passed so that an exception is thrown if the value is out of scope.
  class Enum < Element
    def initialize(name, parent, ctype = nil) # :notnew
      super()

      @name = name
      @parent = parent

      @cprefix = "#{@parent.cname}::" if @parent
      @cname = "#{@cprefix}#{@name}"
      
      @varname = "#{@cname.gsub("::", "_")}"
      @cname = ctype if ctype
  
      @values = []

      @declaration_template = Templates["EnumDeclarations"]
      @definition_template = Templates["EnumDefinitions"]
      @initialization_template = "!enum_values_init!"

      add_expansion 'enum_values_init',
        '@values.collect { |name, value| "rb_define_const(!parent_varname!, \"#{name}\", cxx2ruby(#{value}));" }.join("\n")'
      add_expansion 'enum_cases',
        '@values.collect { |name, value| "case #{value}:" }.join("\n")'
      add_expansion 'enum_name', '@name'
      add_expansion 'enum_cname', '@cname'
      add_expansion 'enum_cprefix', '@cprefix'
      add_expansion 'enum_varname', '@varname'
      add_expansion 'parent_varname', '"r#{@parent.varname}"'
    end

    def add_value(name, value="#{@cprefix}#{name}")
      @values << [name, value]
    end 
  end

end
