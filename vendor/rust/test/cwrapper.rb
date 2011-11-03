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

require 'rust'

Rust::Bindings::create_bindings Rust::Bindings::LangC, "cwrapper_rb" do |b|
  b.include_header 'cwrapper.h', Rust::Bindings::HeaderLocal

  b.add_namespace "RustTestCWrapper", "" do |ns|
    ns.add_class_wrapper 'TestClass', 'test_wrapper_t' do |klass|
      klass.add_constructor 'cwrapper_alloc'

      klass.add_method 'cwrapper_get_integer', 'uint32_t', 'get_integer' do |method|
        method.add_instance_parameter
      end
      klass.add_method 'cwrapper_get_string', 'char*', 'get_string' do |method|
        method.add_instance_parameter
      end

      klass.add_method 'cwrapper_set_string', 'bool', 'set_string' do |method|
        method.add_instance_parameter
        method.add_parameter "char *", "string"
      end

      klass.add_method 'cwrapper_set_integer', 'void', 'set_integer' do |method|
        method.add_instance_parameter
        method.add_parameter "uint32_t", "integer"
      end

      klass.add_cleanup_function 'cwrapper_free((test_wrapper_t*)p);'
    end

    ns.add_function 'cwrapper_get_default_integer', 'uint32_t', 'get_default_integer'

    ns.add_constant 'TestConstant', '1985'
  end
end
