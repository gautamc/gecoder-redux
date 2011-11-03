require File.dirname(__FILE__) + '/spec_helper'

describe 'Interface installed on win32 systems' do
  it 'should be able to load the libraries' do
    # Admittably this is not an especially good test for the library loading 
    # under Windows. It only makes sure that there are no execution errors. This
    # has to be tested in a proper Windows environment to tell whether library
    # loading actually works.
    RUBY_PLATFORM = 'i386-mswin32'
    lambda do
      Gecode.load_bindings_lib
    end.should_not raise_error
  end
end