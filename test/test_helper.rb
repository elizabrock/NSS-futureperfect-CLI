require 'coveralls'
Coveralls.wear_merged!

ENV['FP_ENV'] = 'test'
require "minitest/autorun"
require_relative '../bootstrap_ar'
connect_to 'test'

def run_and_q command
  IO.popen(command, 'r+') do |pipe|
    pipe.puts("q")
    pipe.close_write
    shell_output = pipe.read
  end
end

def strip_control_characters_and_excesses(string)
  string.split("\033[2;0f").last.gsub(/(\e\[\d+\w)|(\e\[\w)/,"")
end

def assert_includes_in_order input, *items
  input = strip_control_characters_and_excesses(input)
  regexp_string = items.join(".*").gsub("?","\\?")
  assert_match /#{regexp_string}/, input.delete("\n"), "Expected /#{regexp_string}/ to match:\n" + input
end

module DatabaseCleaner
  def before_setup
    super
    Project.destroy_all
  end
end
