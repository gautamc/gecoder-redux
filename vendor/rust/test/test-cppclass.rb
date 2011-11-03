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

require 'lib/extension-test'

module Rust::Test

  class CppClassTest < Test::Unit::TestCase
    include ExtensionTest

    def setup
      extension_setup("cppclass", "cc")

      @instance = RustTestCppClass::TestClass.new
    end

    def test_integers
      @instance.action1 1234
      assert @instance.integerValue == 1234, "The integer value does not correspond"
    end

    def test_strings
      @instance.action2 "a test"
      assert @instance.stringValue == "a test", "The string value does not correspond"
    end

    def test_camelcase
      assert( RustTestCppClass::TestClass.instance_methods.include?("integer_value"),
            "The converted CamelCase to ruby_convention is missing." )
      assert( RustTestCppClass::TestClass.instance_method("integer_value") == RustTestCppClass::TestClass.instance_method("integerValue"),
              "The converted CamelCase to ruby_conversion is not an alias of the original method" )

    end

    def test_variable
      random_value = rand(655360)
      
      @instance.variable = random_value

      assert( @instance.variable == random_value,
               "The set/get of variable doe snot work." )
    end

    def test_enum_value
      assert( RustTestCppClass::TestClass::Foo1 == 0,
              "Foo1 value is not the expected one." )
    end

    def test_enum_invalid
      @instance.test_enum RustTestCppClass::TestClass::Foo1
      begin
        @instance.test_enum 4
      rescue ArgumentError
      end

      begin
        @instance.test_enum 255
      rescue ArgumentError
      end
    end
  end

end
