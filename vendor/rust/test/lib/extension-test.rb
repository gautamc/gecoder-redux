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

require 'test/unit'
require 'rbconfig'
require 'pathname'
require 'tmpdir'

$: << (Pathname.new(File.dirname(__FILE__) ) + "../..").realpath

module Rust

# The Rust::Test module contains the classes used for Rust regression
# testing, both the generic ones, and the actual test ones.
module Test
  # This module is de-facto a subclass of Test::Unit::TestCase, but
  # because of the way the tests work, so we can't just derive from
  # that, and instead we use mixins.
  module ExtensionTest

    def extension_setup(extname, language)
      raise UnnamedExtension unless extname

      tempdir = Pathname.new(Dir::tmpdir) + "rust-test.#{$$}/#{extname}"
      tempdir.mkpath

      return if File.exist?("#{tempdir}/#{extname}_rb.so")

      assert( (!File.exist?("#{tempdir}/#{extname}_rb.cc") and !File.exist?("#{tempdir}/#{extname}_rb.hh")),
              "There are already generated files." )

      puts "Building extension #{extname} (#{language})"

      case language
      when 'c' then [ 'c', 'h', 'rb' ]
      when 'cc' then [ 'cc', 'hh', 'rb' ]
      when 'rb' then [ 'rb' ]
      end.each do |ext|
        assert( File.exist?("#{extname}.#{ext}"),
                "Missing prerequisite #{extname}.#{ext} source file" )
      end

      sourcedir = Dir.pwd
      Dir.chdir(tempdir) do
        load "#{sourcedir}/#{extname}.rb"
      end

      assert( (File.exists?("#{tempdir}/#{extname}_rb.cc") && File.exist?("#{tempdir}/#{extname}_rb.hh")),
              "The extension's source files weren't generated.")

      cxx = ENV['CXX'] ? ENV['CXX'] : 'c++'
      cc =  ENV['CC'] ? ENV['CC'] : 'cc'
      cxxflags = "#{ENV['CXXFLAGS']} -I#{Config::CONFIG["archdir"]} -I. -I../include -DDEBUG -fPIC"
      cflags = "#{ENV['CFLAGS']} -I. -DDEBUG -fPIC"
      ldflags = "#{ENV['LDFLAGS']} -Wl,-z,defs -shared"

      cmdlines = []
      case language
      when 'cc'
        sourcefile = "#{extname}.cc"
      when 'c'
        sourcefile = "#{tempdir}/#{extname}.o"
        cmdlines << "#{cc} #{cflags} #{extname}.c -c -o #{tempdir}/#{extname}.o"
      end

      cmdlines << "#{cxx} #{cxxflags} #{ldflags} #{sourcefile} #{tempdir}/#{extname}_rb.cc -o #{tempdir}/#{extname}_rb.so -lruby"

      cmdlines.each do |cmd|
        puts cmd
        ret = system cmd
        assert ret, "Building of extension #{extname} failed."
      end

      require "#{tempdir}/#{extname}_rb.so"
    end
  end

end
end
