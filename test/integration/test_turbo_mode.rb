require_relative '../test_helper'

describe "working through a project list, quickly!" do
  include DatabaseCleaner

  describe "the amount of time to work" do
    it "should decrease the amount of time to work next time" do
      project = Project.create!(name: "Foo", minutes_to_work: 30)
      Project.create!(name: "Bar", minutes_to_work: 30)
      shell_output = ""
      IO.popen('./futureperfect start --fast', 'r+') do |pipe|
        pipe.puts("q")
        pipe.close_write
        shell_output = pipe.read
      end
      assert_includes shell_output, "00:59"
    end
  end

  describe "when a project is worked all the way through" do
    it "should increase the amount of time to work next time" do
      project = Project.create!(name: "Foo", minutes_to_work: 0)
      shell_output = ""
      IO.popen('./futureperfect start', 'r+') do |pipe|
        pipe.puts("q")
        pipe.close_write
        shell_output = pipe.read
      end
      assert_equal 1, project.reload.minutes_to_work
    end
  end
end

