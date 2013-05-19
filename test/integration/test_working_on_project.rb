
require_relative '../test_helper'

class TestWorkingOnProject < MiniTest::Unit::TestCase
  include DatabaseCleaner

  def test_working_when_there_are_no_projects
    assert Project.all.empty?
    actual = `ruby futureperfect start`
    assert actual.include?( "You must enter a project before you can start working" ), "Should have been an error message, was: '#{actual}'"
  end

  def test_projects_are_started_in_order_of_least_recently_worked
    Project.create(name: 'foo', last_worked_at: 2.days.ago)
    Project.create(name: 'bar', last_worked_at: 1.days.ago)
    Project.create(name: 'grille', last_worked_at: Time.now)
    Project.create(name: 'never', last_worked_at: nil)
    actual = `ruby futureperfect start`
    assert actual.include?( "never" ), "Should have been 'never', was: '#{actual}'"
    actual = `ruby futureperfect start`
    assert actual.include?( "foo" ), "Should have been 'foo', was: '#{actual}'"
  end

  def test_projects_are_given_correct_last_worked_at
    Project.create(name: 'never', last_worked_at: nil)
    `ruby futureperfect start`
    # Note: this test is susceptible to timing issues, so I used
    # assert_in_delta!
    assert_in_delta Time.now.to_i, Project.last.last_worked_at.to_i, 5
  end
end
