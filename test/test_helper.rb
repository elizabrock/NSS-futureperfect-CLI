require 'coveralls'
# Coveralls::Output.silent = true
# Coveralls.wear!

require "minitest/autorun"
require 'mocha/setup'
require_relative '../bootstrap_ar'

connect_to 'test'

ENV['FP_ENV'] = 'test'

def run_and_q command
  IO.popen(command, 'r+') do |pipe|
    pipe.puts("q")
    pipe.close_write
    shell_output = pipe.read
  end
end

def strip_control_characters(string)
  string = string.gsub(/(\n)|(\[\d+\w)|(\[\w)/,"")
  string.chars.inject("") do |str, char|
    unless char.ascii_only? and (char.ord < 32 or char.ord == 127)
      str << char
    end
    str
  end
end

def assert_includes_in_order input, *items
  input = strip_control_characters(input)
  regexp_string = items.join(".*")
  regexp = /#{regexp_string}/
  assert_match regexp, input
end

module DatabaseCleaner
  def before_setup
    super
    Project.destroy_all
  end
end
