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

require 'rust/namespace'

module Rust
  # Base class to use to create bindings for ruby.
  # You shouldn't instantiate this manually, but rather use the
  # create_bindings function.
  class Bindings
    # Constant to use with Bindings.create_bindings to state that the
    # bindings that are to be created are for a C library.
    LangC = "c"

    # Constant to use with Bindings.create_bindings to state that the
    # bindings that are to be created are for a C++ library.
    LangCxx = "cxx"

    # Constant to use with include_header method to state that the
    # included header is a system library header.
    HeaderGlobal = "global"

    # Constant to use with include_header method to state that the
    # included header is a local header.
    HeaderLocal = "local"

    def initialize(name, lang) # :notnew:
      @name = name
      @lang = lang

      @modules = Array.new
      @custom_definition = Array.new
      @custom_initialization = Array.new
      
      @cxx_includes = ""
      @c_includes = ""
    end

    # This function is called when creating Ruby bindings for a
    # library.
    #
    # The first parameter has to be one between Rust::Bindings::LangC
    # or Rust::Bindings::LangCxx, and tells Rust which programming
    # language the library to bind is written into.
    #
    # Please note that Rust always generates C++ code even when
    # binding a library written in C, as STL templates are used all
    # over the generics code.
    def Bindings.create_bindings(lang, name)
      bindings = 
        case lang
        when Bindings::LangCxx, Bindings::LangC
          bindings = Bindings.new(name, lang)
        else
          raise ArgumentError, "#{lang} is not a valid value for type parameter"
        end

      yield bindings

      header = File.new("#{name}.hh", File::CREAT|File::TRUNC|File::RDWR)
      unit = File.new("#{name}.cc", File::CREAT|File::TRUNC|File::RDWR)
      
      header.puts bindings.header
      unit.puts bindings.unit

      header.close
      unit.close
    end

    # Adds an include header with the specified name.
    # This function adds to the list of header files to include the
    # one with the specified name.
    #
    # If the scope paramether is set to Bindings.HeaderLocal, the name of
    # the header file will be enclosed in double quotes ("") while
    # including it, while it will be included it in angle quotes if
    # the parameter is set to Bindings.HeaderGlobal (the default).
    def include_header(name, scope = Bindings::HeaderGlobal, lang = @lang)
      name = 
        case scope
        when HeaderLocal then "\"#{name}\""
        when HeaderGlobal then "<#{name}>"
        else
          raise ArgumentError, "#{scope} not a valid value for scope parameter."
        end

      case lang
      when Bindings::LangCxx
        @cxx_includes << "\n#include #{name}"
      when Bindings::LangC
        @c_includes << "\n#include #{name}"
      end
    end

    # Binds a new Namespace to a Ruby module; the name parameter is
    # used as the name of the module, while the cxxname one (if not
    # null) is used to indicate the actual C++ namespace to use; when
    # binding a C library, you should rather use the add_module
    # function, although that's just a partial wrapper around this one.
    def add_namespace(name, cxxname = nil)
      cxxname = name if cxxname == nil 

      ns = Namespace.new(name, cxxname)

      yield ns

      @modules << ns
    end

    # Create a new Ruby module with the given name; this is used when
    # binding C libraries, as they don't use namespace, so you have to
    # create the modules from scratch.
    def add_module(name)
      add_namespace(name, "")
    end

    # Returns the content of the header for the bindings, recursively
    # calling the proper functions to get the declarations for the
    # modules bound and so on.
    #
    # This should *never* be used directly
    def header
      Templates["BindingsHeader"].
        gsub("!bindings_name!", @name).
        gsub("!modules_declaration!", @modules.collect { |ns| ns.declaration }.join("\n")).
        gsub("!cxx_includes!", @cxx_includes).
        gsub("!c_includes!", @c_includes)
    end

    # Returns the content of the unit for the bindings, recursively
    # calling the proper functions to get the definitions and the
    # initialisation function for the modules bound and so on.
    #
    # This should *never* be used directly
    def unit
      Templates["BindingsUnit"].
        gsub("!bindings_name!", @name).
        gsub("!modules_initialization!", @modules.collect { |ns| ns.initialization }.join("\n")).
        gsub("!modules_definition!", @modules.collect { |ns| ns.definition }.join("\n")).
        gsub("!custom_definition!", @custom_definition.join("\n")).
        gsub("!custom_initialization!", @custom_initialization.join("\n"))
    end
    
    def add_custom_definition(element)
      @custom_definition << element
    end
    
    def add_custom_initialization(initialization)
      @custom_initialization << initialization
    end
  end

end
