require 'bundler'
Bundler.setup
require "rubygems"
require "active_record"

# For coveralls:
if ENV['FP_ENV'] == 'test'
  require 'simplecov'
  require 'coveralls'
  Coveralls::Output.silent = true
  SimpleCov.start do
    formatter Coveralls::SimpleCov::Formatter
    command_name "tests"
  end
end

project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/lib/*.rb").each{|f| require f}
Dir.glob(project_root + "/app/**/*.rb").each{|f| require f}

def test_env?
  ENV['FP_ENV'] == "test"
end

def connect_to env
  connection_details = YAML::load(File.open('config/database.yml'))
  ActiveRecord::Base.establish_connection(connection_details[env])
end
