/* Copyright (c) 2005-2007 Diego Pettenò <flameeyes@gmail.com>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#include <string>
#include <stdint.h>

class TestClass {
public:
  TestClass();
  ~TestClass();

  void action1(uint32_t unused_parameter);
  void action2(char *string);
  void action3(const TestClass &tc);

  std::string stringValue() {
    return str;
  }

  uint32_t integerValue() {
    return val;
  }

  uint32_t variable() {
    return m_variable;
  }

  uint32_t setVariable(uint32_t value) {
    m_variable = value;
  }

  enum Test {
    Foo1, Foo2, Foo3, Foo4, Foo6 = 6
  };

  void testEnum(Test param) {
  }

protected:
  uint32_t val;
  std::string str;

  uint32_t m_variable;
};



