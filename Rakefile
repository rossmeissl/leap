require 'bundler'
Bundler::GemHelper.install_tasks

require 'bueller'
Bueller::Tasks.new

require 'rake'
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
task :default => :test

begin
  require 'rake/rdoctask'
  Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = 'leap'
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue LoadError
   puts "Rdoc is not available"
end
