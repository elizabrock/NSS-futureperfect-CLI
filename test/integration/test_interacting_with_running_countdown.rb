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

    assert_includes_in_order shell_output, "Foo", "Bar", "Done!"
  end

  def test_s_skips_project_and_marks_it_as_unstarted
    april_1 = Date.parse("2013/04/01 00:00:00")
    foo = Project.create!(name: "Foo", last_worked_at: Date.parse("2013/05/01 00:00:00"))
    bar = Project.create!(name: "Bar", last_worked_at: april_1)
    shell_output = ""
    IO.popen('./futureperfect start', 'r+') do |pipe|
      # starts on Bar
      pipe.puts("s")
      # should skip "Bar", start on "Foo"
      pipe.puts("q")
      pipe.close_write
      shell_output = pipe.read
    end

    assert_includes_in_order shell_output, "Skipping Bar", "Foo", "Done!"
    bar.reload
    assert_equal april_1.to_time, bar.last_worked_at.to_time
    assert_in_delta bar.skip_until.to_time, (Date.today + 1).to_time, 5
  end
end
