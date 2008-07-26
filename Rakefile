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