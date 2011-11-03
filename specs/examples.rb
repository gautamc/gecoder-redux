require File.dirname(__FILE__) + '/spec_helper'
require 'open3'

# This spec checks that the examples are still working.
files = Dir["#{File.dirname(__FILE__)}/../example/*.rb"]
files.delete_if do |file|
  file =~ /example_helper.rb/
end

files.each do |example|
  describe "Example (#{File.basename(example)})" do
    it 'should not output errors' do
      _, _, stderr = Open3.popen3("ruby #{example} 1> /dev/null")
      stderr.gets.should be_nil
    end
  end
end
