require 'lib/gecoder/version'

desc "Tag the release in svn"
task :tag do
  base_url = `svn info`.match(/Repository Root: (.*)/n)[1]
  unless base_url.include? ENV['RUBYFORGE_USER']
    base_url.gsub!('rubyforge', "#{ENV['RUBYFORGE_USER']}@rubyforge")
  end
  from = base_url + '/trunk'
  to = base_url + "/tags/gecoder-#{GecodeR::VERSION}"
  options = "-m \"Tag release Gecode/R #{GecodeR::VERSION}\""

  puts "Creating tag in SVN"
  tag_cmd = "svn cp #{from} #{to} #{options}"
  `#{tag_cmd}` ; raise "ERROR: #{tag_cmd}" unless $? == 0
end
