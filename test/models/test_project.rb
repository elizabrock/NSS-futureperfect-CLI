require_relative '../test_helper'

describe Project do
  include DatabaseCleaner

  describe "#minutes_to_work" do
    it "should have a default minutes_to_work of 30" do
      project = Project.create!(name: "Foo")
      assert_equal 30, project.minutes_to_work
    end
    it "should be settable" do
      project = Project.create!(name: "Foo", minutes_to_work: 1)
      project.reload
      assert_equal 1, project.minutes_to_work
    end
  end
end
