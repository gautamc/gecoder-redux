require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

RCOV_DIR = "#{File.dirname(__FILE__)}/../doc/output/coverage"

desc "Run all specs (except examples) with rcov"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files = FileList['specs/**/*.rb']
  t.spec_files.exclude 'examples.rb'
  t.rcov = true
  t.rcov_opts = ['--exclude examples', '--exclude specs']
  t.rcov_dir = RCOV_DIR
end

RCov::VerifyTask.new(:verify_rcov => :rcov) do |t|
  t.threshold = 100.0
  t.index_html = "#{RCOV_DIR}/index.html"
end
