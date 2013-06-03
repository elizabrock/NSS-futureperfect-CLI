require_relative '../test_helper'

describe "working through a project list" do
  include DatabaseCleaner


  describe "when a project is skipped" do
    it "should decrease the amount of time to work next time" do
      project = Project.create!(name: "Foo", minutes_to_work: 30)
      Project.create!(name: "Bar", minutes_to_work: 30)
      shell_output = ""
      IO.popen('./futureperfect start', 'r+') do |pipe|
        pipe.puts("n")
        pipe.puts("q")
        pipe.close_write
        shell_output = pipe.read
      end
      assert_equal 29, project.reload.minutes_to_work
    end
  end

  describe "when a project is worked all the way through" do
    it "should increase the amount of time to work next time" do
      project = Project.create!(name: "Foo", minutes_to_work: 0)
      shell_output = ""
      IO.popen('./futureperfect start', 'r+') do |pipe|
        pipe.puts("n")
        pipe.puts("q")
        pipe.close_write
        shell_output = pipe.read
      end
      assert_equal 1, project.reload.minutes_to_work
    end
  end
end
