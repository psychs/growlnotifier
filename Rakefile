require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.options = '-rs'
end

Rake::RDocTask.new do |rd|
  #rd.main = "README.rdoc"
  #rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.rdoc_files.include("lib/**/*.rb")
end