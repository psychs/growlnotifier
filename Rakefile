require 'rubygems'
require 'rake/testtask'

require 'lib/growl.rb'

# Install the Hoe gem to be able to use the deploy tasks.
begin
  require 'hoe'
  
  class Hoe
    def extra_deps
      @extra_deps.reject do |x|
        Array(x).first == 'hoe'
      end
    end
  end
  
  Hoe.new('growlnotifier', Growl::Notifier::VERSION) do |p|
    p.author = ["Satoshi Nakagawa", "Eloy Duran"]
    p.description = "A ruby library which allows you to send Growl notifications."
    p.email = ["psychs@limechat.net", "e.duran@superalloy.nl"]
    p.summary = "Growl::Notifier is a OSX RubyCocoa class that allows your application to post notifications to the Growl daemon."
    p.url = "http://growlnotifier.rubyforge.org/"
    p.clean_globs = ['coverage'] # Remove this directory on "rake clean"
    p.remote_rdoc_dir = '' # Release to root
  end
rescue LoadError
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