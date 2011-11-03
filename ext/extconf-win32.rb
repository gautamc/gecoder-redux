require 'mkmf'
require 'pathname'

# Set up some important locations.
ROOT = Pathname.new(File.dirname(__FILE__) + '/..').realpath
RUST_INCLUDES = "#{ROOT}/vendor/rust/include"
BINDINGS_DIR = "#{ROOT}/lib/gecoder/bindings" 
EXT_DIR = "#{ROOT}/ext"
ORIGINAL_DIR = Pathname.new('.').realpath
WIN32_DIR = "#{ROOT}/vendor/gecode/win32"
GECODE_DLL_DIR = "#{WIN32_DIR}/lib"
GECODE_INCLUDES = "#{WIN32_DIR}/include"

# Find the Gecode libraries.
find_library("WindowsgecodesupportWindows", nil, GECODE_DLL_DIR)
find_library("WindowsgecodekernelWindows", nil, GECODE_DLL_DIR)
find_library("WindowsgecodeintWindows", nil, GECODE_DLL_DIR)
find_library("WindowsgecodesetWindows", nil, GECODE_DLL_DIR)
find_library("WindowsgecodesearchWindows", nil, GECODE_DLL_DIR)
find_library("WindowsgecodeminimodelWindows", nil, GECODE_DLL_DIR)

find_library('stdc++', nil)

# The last flag is a bit mysterious, but it works.
cppflags = "-I#{RUST_INCLUDES} -I#{EXT_DIR} -I#{GECODE_DLL_DIR} -I#{GECODE_INCLUDES} -DGECODE_BUILD_SET"

# Include the Rust headers and Gecode bindings.
with_cppflags(cppflags) {
  # Include the Rust headers.
  find_header("rust_conversions.hh", RUST_INCLUDES)
  find_header("rust_checks.hh", RUST_INCLUDES)
}

# This is an ugly way to add "CXX = mingw32-g++" to the generated makefile. I
# couldn't see any other way provided by mkmf than to extend its definition of
# configuration.
alias old_configuration configuration
def configuration(srcdir)
  old_configuration(srcdir) << "CXX = mingw32-g++"
end

# Load the specification of the bindings. This creates the headers in the 
# current directory.
load "#{BINDINGS_DIR}/bindings.rb"

# Create the makefile.
create_makefile("gecode")
