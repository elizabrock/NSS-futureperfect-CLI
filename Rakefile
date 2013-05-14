#!/usr/bin/env ruby
# -*- ruby -*-

require 'rake/testtask'
require_relative 'bootstrap_ar'

Rake::TestTask.new do |t|
 t.libs << 'test'
end

desc "Run tests"
task :default => :test
