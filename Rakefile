# Rakefile
require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('scrobbler', '0.2.0') do |p|
  p.description = "wrapper for audioscrobbler (last.fm) web services"
  p.url         = "http://scrobbler.rubyforge.org"
  p.author      = "John Nunemaker"
  p.email       = "nunemaker@gmail.com"
  p.extra_deps  = [['hpricot', '>=0.4.86'], ['activesupport', '>=1.4.2']]
  p.need_tar_gz = false
end

desc 'Upload website files to rubyforge'
task :website do
  config = YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))
  host = "#{config["username"]}@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/#{RUBYFORGE_PROJECT}/"
  # remote_dir = "/var/www/gforge-projects/#{RUBYFORGE_PROJECT}/#{GEM_NAME}"
  local_dir = 'website'
  sh %{rsync -av #{local_dir}/ #{host}:#{remote_dir}}
end

desc 'Preps the gem for a new release'
task :prepare do
  %w[manifest build_gemspec].each do |task|
    Rake::Task[task].invoke
  end
end