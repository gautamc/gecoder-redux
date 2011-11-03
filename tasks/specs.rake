require 'spec/rake/spectask'

spec_files = FileList['specs/**/*.rb']

desc 'Run all specs'
Spec::Rake::SpecTask.new(:specs) do |t|
  t.libs = ['lib']
  t.spec_files = spec_files
end

desc 'Run specs for the examples'
Spec::Rake::SpecTask.new(:example_specs) do |t|
  t.libs = ['lib']
  t.spec_files = FileList['specs/examples.rb']
end

desc 'Generate an rspec html report'
Spec::Rake::SpecTask.new(:spec_html) do |t|
  t.spec_files = spec_files
  t.spec_opts = ['--format html:doc/output/rspec.html','--backtrace']
end
