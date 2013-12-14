require_relative '../test_helper'

class TestWorkingOnProject < MiniTest::Unit::TestCase
  include DatabaseCleaner

  def test_q_causes_program_to_exit_without_changing_work_status
    project = Project.create!(name: "Foo")
    shell_output = ""
    IO.popen('./futureperfect start', 'r+') do |pipe|
      pipe.puts("q")
      pipe.close_write
      shell_output = pipe.read
    end
    assert_includes shell_output, "Done!"
    project.reload
    assert_nil project.skip_until
  end

  def test_a_adds_a_project
    project = Project.create!(name: "Foo")
    shell_output = ""
    original_project_count = Project.count
    IO.popen('./futureperfect start', 'r+') do |pipe|
      pipe.puts("add New Project")
      pipe.puts("q")
      pipe.close_write
      shell_output = pipe.read
    end
    assert_includes shell_output, "New Project has been added!"
    assert_equal Project.count, original_project_count + 1
    assert_equal Project.last.name, "New Project"
  end

  def test_a_doesnt_fail_on_duplicates
    project = Project.create!(name: "Foo")
    project = Project.create!(name: "Bar")
    shell_output = ""
    original_project_count = Project.count
    IO.popen('./futureperfect start', 'r+') do |pipe|
      pipe.puts("add Foo")
      pipe.puts("n")
      pipe.puts("q")
      pipe.close_write
      shell_output = pipe.read
    end
    assert_equal Project.count, original_project_count
    assert_includes_in_order shell_output, "Foo", "must be unique", "Bar", "Done!"
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

  def test_done_causes_skip_to_next_project
    project = Project.create!(name: "Foo")
    Project.create!(name: "Bar")
    shell_output = ""
    IO.popen('./futureperfect start', 'r+') do |pipe|
      pipe.puts("done")
      pipe.puts("q")
      pipe.close_write
      shell_output = pipe.read
    end

    assert_includes_in_order shell_output, "Done with Foo forever!", "Bar", "Done!"
    project.reload
    assert project.complete?
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

  def test_end_of_countdown_prompts_for_c_or_q
    foo = Project.create!(name: "Foo", minutes_to_work: 0)
    bar = Project.create!(name: "Bar", minutes_to_work: 0)
    bar = Project.create!(name: "Zed", minutes_to_work: 0)
    shell_output = ""
    IO.popen('./futureperfect start', 'r+') do |pipe|
      # starts on Foo, finishes Foo and prompts for c/q
      pipe.puts("c")
      # should continue to bar, finish bar, and prompt for c/q again
      pipe.puts("q")
      pipe.close_write
      shell_output = pipe.read
    end

    assert_includes_in_order shell_output, "Foo", "Do you wish to continue? Press any key to continue or 'q' to quit", "Bar", "Do you wish to continue? Press any key to continue or 'q' to quit", "Done!"
  end

  def test_end_of_countdown_ends_if_all_work_is_completed
    foo = Project.create!(name: "Foo", minutes_to_work: 0, skip_until: Date.today + 1)
    bar = Project.create!(name: "Bar", minutes_to_work: 0, last_worked_at: Time.now - (23*60*60))
    bar = Project.create!(name: "Grille", minutes_to_work: 0)
    bar = Project.create!(name: "Zed", minutes_to_work: 0)
    shell_output = ""
    IO.popen('./futureperfect start', 'r+') do |pipe|
      # starts on Grille, finishes Grille and prompts for c/q
      pipe.puts("c")
      # should continue to Zed, finish Zed, and quits with exit message
      pipe.close_write
      shell_output = pipe.read
    end

    assert_includes_in_order shell_output, "Grille", "Do you wish to continue? Press any key to continue or 'q' to quit", "Zed", "All your work is done.  Goodbye!"
  end
end
