#!/usr/bin/env ruby
# -*- ruby -*-

require 'rake/testtask'
require_relative 'bootstrap_ar'

Rake::TestTask.new do |t|
 t.libs << 'test'
end

desc "Run tests"
task :default => :test

require 'active_record'
require 'yaml'

db_namespace = namespace :db do
  desc "Migrate the db"
  task :migrate do
    connection_details = YAML::load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(connection_details)
    ActiveRecord::Migrator.migrate("db/migrate/")
    db_namespace["schema:dump"].invoke
  end
  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
  task :rollback do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, step)
    db_namespace["schema:dump"].invoke
  end
  namespace :schema do
    desc 'Create a db/schema.rb file that can be portably used against any DB supported by AR'
    task :dump do
      require 'active_record/schema_dumper'
      connection_details = YAML::load(File.open('config/database.yml'))
      ActiveRecord::Base.establish_connection(connection_details)
      filename = ENV['SCHEMA'] || "db/schema.rb"
      File.open(filename, "w:utf-8") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end
end
