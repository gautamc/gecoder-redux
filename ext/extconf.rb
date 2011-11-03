require 'mkmf'
require 'pathname'

# Set up some important locations.
ROOT = Pathname.new(File.dirname(__FILE__) + '/..').realpath
RUST_INCLUDES = "#{ROOT}/vendor/rust/include"
BINDINGS_DIR = "#{ROOT}/lib/gecoder/bindings" 
EXT_DIR = "#{ROOT}/ext"
ORIGINAL_DIR = Pathname.new('.').realpath
# The Gecode libraries are placed in the lib directory when using the 
# gecoder-with-gecode distribution.
GECODE_LIB_DIR = "#{ROOT}/lib/lib"
GECODE_INCLUDE_DIR = "#{ROOT}/lib/include"
distributed_with_gecode = File.exist?(GECODE_LIB_DIR) and 
  File.exist?(GECODE_INCLUDE_DIR)

# Find the Gecode libraries.
find_library("gecodesupport", "", GECODE_LIB_DIR)
find_library("gecodekernel", "", GECODE_LIB_DIR)
find_library("gecodeint", "", GECODE_LIB_DIR)
find_library("gecodeset", "", GECODE_LIB_DIR)
find_library("gecodesearch", "", GECODE_LIB_DIR)
find_library("gecodeminimodel", "", GECODE_LIB_DIR)

cppflags = "-I#{RUST_INCLUDES} -I#{EXT_DIR}"
cppflags << " -I#{GECODE_INCLUDE_DIR}" if distributed_with_gecode
with_cppflags(cppflags) {
  find_header("rust_conversions.hh", RUST_INCLUDES)
  find_header("rust_checks.hh", RUST_INCLUDES)
}

if distributed_with_gecode
  # This is an ugly way to set LD_RUN_PATH. I couldn't see any other way provided 
  # by mkmf or RubyGems.
  alias old_configuration configuration
  def configuration(srcdir)
    old_configuration(srcdir) << "export LD_RUN_PATH=#{GECODE_LIB_DIR}"
  end
end

# Load the specification of the bindings. This creates the headers in the 
# current directory.
load "#{BINDINGS_DIR}/bindings.rb"

# Create the makefile.
create_makefile("gecode")
