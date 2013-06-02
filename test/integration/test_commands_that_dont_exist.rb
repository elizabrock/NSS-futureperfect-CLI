require_relative '../test_helper'

class TestCommandsThatDontExist < MiniTest::Unit::TestCase
  include DatabaseCleaner

  def test_help_message_is_printed
    output = `ruby futureperfect foo remove`
    ["list", "add", "remove", "start"].each do |command|
      assert_includes output, command
    end
  end

  def test_user_sees_error_message
    output = `ruby futureperfect foo foo`
    message = "FuturePerfect does not support the 'foo' command."
    assert_includes output, message
  end

  def test_help_message_is_printed_with_help_command
    output = `ruby futureperfect help`
    ["list", "add", "remove", "start"].each do |command|
      assert_includes output, command
    end
  end

  def test_help_command_doesnt_print_error_message
    output = `ruby futureperfect help`
    message = "FuturePerfect does not support"
    refute_includes output, message
  end
end
