require 'rubygems'
require 'rake/testtask'

require 'rubygems'
require 'hoe'
require 'lib/growl.rb'

Hoe.new('GrowlNotifier', Growl::Notifier::VERSION) do |p|
  p.author = ["Satoshi Nakagawa", "Eloy Duran"]
  p.description = "A ruby library which allows you to send Growl notifications."
  p.email = ["psychs@limechat.net", "e.duran@superalloy.nl"]
  p.summary = "A ruby library which allows you to send Growl notifications."
  p.url = "http://growlnotifier.rubyforge.org/"
  p.clean_globs = ['coverage'] # Remove this directory on "rake clean"
  p.remote_rdoc_dir = '' # Release to root
end

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.options = '-rs'
end

desc "Run code-coverage analysis using rcov"
task :coverage do
  rm_rf "coverage"
  sh "rcov test/*_test.rb --exclude=mocha,RubyCocoa.framework,osx,rcov"
  sh "open coverage/index.html"
end