require_relative '../test_helper'

class TestWorkingOnProject < MiniTest::Unit::TestCase
  include DatabaseCleaner

  def test_q_causes_program_to_exit
    Project.create!(name: "Foo")
    shell_output = ""
    IO.popen('./futureperfect start', 'r+') do |pipe|
      pipe.puts("q")
      pipe.close_write
      shell_output = pipe.read
    end
    assert_includes shell_output, "Done!"
  end

  def test_n_causes_skip_to_next_project
    Project.create!(name: "Foo")
    Project.create!(name: "Bar")
    shell_output = ""
    IO.popen('./futureperfect start', 'r+') do |pipe|
      pipe.puts("n")
      pipe.puts("q")
      pipe.close_write
      shell_output = pipe.read
    end
    assert_includes shell_output, "Bar"
    assert_includes shell_output, "Foo"
    assert_includes shell_output, "Done!"

    assert_includes_in_order shell_output, "Foo", "Bar", "Done!"
    assert_includes_in_order shell_output, "Bar", "Foo", "Done!"
  end
end
