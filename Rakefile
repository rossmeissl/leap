require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "leap"
    gem.summary = %Q{A heuristics engine for your Ruby objects}
    gem.description = %Q{Leap to conclusions}
    gem.email = "andy@rossmeissl.net"
    gem.homepage = "http://github.com/rossmeissl/leap"
    gem.authors = ["Andy Rossmeissl", "Seamus Abshere"]
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_dependency "characterizable", ">=0.0.11"
    gem.add_dependency 'blockenspiel', '>=0.3.2'
    gem.add_dependency 'activesupport', '>=3.0.0.beta2'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "leap #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
