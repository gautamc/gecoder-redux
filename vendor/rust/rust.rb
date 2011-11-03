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

require 'pathname'

# Rust is a Ruby bindings generator, developed by Diego Pettenò
# <flameeyes@gmail.com>, based on a simpler Ruby bindings generator
# that was used for RubyTag++ and ruby-hunspell.
#
# The original bindings generator was designed to permit a 1:1 mapping
# between C++ classes and Ruby classes, as otherwise writing Ruby
# bindings for a C++-based library would have consisted of a long
# series of generic functions to convert the types from one language
# to the other and to call the methods.
#
# Most C bindings, instead, either writes a lot of C code to create
# "fake" Classes out of a vaguely object-oriented C API, or simply
# create a module where to put all the C functions to call.
#
# The objective of Rust is to allow the description of a C or C++
# interface, through the creation of 1:1 class mappings or the design
# of "fake" classes out of C functions, without the need to actually
# write all the generic code, as that does not really change beside
# names, types and parameters.
module Rust

  # The Template singleton class is used to simulate a big hash of
  # templates, loaded with the data from the templates/ subdirectory.
  # In truth the templates are loaded only when requested, removing
  # the one-line comments found inside the files (as they are usually
  # just for documenting that particular template). 
  class Templates
    @cache = { }
    @tpls_dir = (Pathname.new File.dirname(__FILE__)) + "rust/templates"

    def Templates.[](name)
      return @cache[name].dup if @cache[name]

      pn = @tpls_dir + "#{name}.rusttpl"
      raise "Template #{name} not found." unless pn.exist?

      @cache[name] = pn.read.gsub(/\/\/.*$\n?/, '')
      return @cache[name].dup
    end
  end
end

require 'rust/bindings'
