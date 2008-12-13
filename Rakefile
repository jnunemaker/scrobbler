# Rakefile
require 'rubygems'
require 'rake'
require 'echoe'
require 'lib/scrobbler/version'

WEBSITE_PATH = 'jnunemaker@rubyforge.org:/var/www/gforge-projects/scrobbler'

Echoe.new('scrobbler', Scrobbler::Version) do |p|
  p.description     = "wrapper for audioscrobbler (last.fm) web services"
  p.url             = "http://scrobbler.rubyforge.org"
  p.author          = ['John Nunemaker', 'Jonathan Rudenberg']
  p.email           = "nunemaker@gmail.com"
  p.extra_deps      = [['hpricot', '>=0.4.86'], ['activesupport', '>=1.4.2']]
  p.need_tar_gz     = false
  p.docs_host       = WEBSITE_PATH
  p.ignore_pattern  = /website/
end

desc 'Upload website files to rubyforge'
task :website do
  sh %{rsync -av website/ #{WEBSITE_PATH}}
  Rake::Task['website_docs'].invoke
end

task :website_docs do
  Rake::Task['redocs'].invoke
  sh %{rsync -av doc/ #{WEBSITE_PATH}/docs}
end

desc 'Preps the gem for a new release'
task :prepare do
  %w[manifest build_gemspec].each do |task|
    Rake::Task[task].invoke
  end
end