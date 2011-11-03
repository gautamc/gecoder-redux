# Copyright (c) 2007 David Cuadrado <krawek@gmail.com>
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
  class Type
    attr_reader :valid_name
    attr_reader :name
    
    def initialize(name)
      @name = name
      @valid_name = name.dup.to_s
      
      if name.include?("*")
        @is_pointer = true
        @valid_name.gsub!("*", "Ptr")
      else
      
      if not name.index(/\[\s*\]/).nil?
        @valid_name.gsub!(/\[\s*\]/, "Array")
        @is_array = true
      end
      
      end
      
      @valid_name = @valid_name.gsub("::", "_").gsub(/[&\s<>]/, "")
    end
    
    def pointer?
      @is_pointer == true
    end
    
    def array?
      @is_array == true
    end
    
    def native?
      [ /(u){0,1}int(\d\d_t){0,1}\s*\*{0,1}/, /float\s*\*{0,1}/, /double\s*\*{0,1}/, /char\s*\*{0,1}/, /bool/, /(std::){0,1}string/ ].each { |type|
        if @name =~ type
          return true
        end
      }
      
      false
    end
    
    def ruby_type?
      @name == "VALUE"
    end
    
    def to_s
      @valid_name.dup
    end
    
  end
end # module


if __FILE__ == $0 # tests
  
  def showtype(type)
    puts "Name: #{type.name}"
    puts "Valid name: #{type.valid_name}"
    puts "Is native: #{type.native?}"
    puts "Is pointer: #{type.pointer?}"
  end
  
  showtype Rust::Type.new("int *")
  
  showtype Rust::Type.new("Namespace::Class")
  
  showtype Rust::Type.new("Namespace::SubNamespace::Class *")
  
end






