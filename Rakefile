require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

task :default => :test
task :clean => [:clobber_package, :clobber_rdoc]

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.options = '-rs'
end

Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/**/*.rb")
end

Rake::GemPackageTask.new(eval(File.read('growlnotifier.gemspec'))) do |p|
  p.need_tar = true
  p.need_zip = true
end

desc 'Build and install the gem'
task :install => :gem do
  sh "sudo gem install pkg/growlnotifier*.gem"
end

desc "Run code-coverage analysis using rcov"
task :coverage do
  rm_rf "coverage"
  sh "rcov test/*_test.rb --exclude=mocha,RubyCocoa.framework,osx,rcov"
  sh "open coverage/index.html"
end