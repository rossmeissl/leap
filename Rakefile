#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake'
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'bueller'
Bueller::Tasks.new

task :default => :test

require 'yard'
YARD::Rake::YardocTask.new do |y|
  y.options << '--no-private'
end
