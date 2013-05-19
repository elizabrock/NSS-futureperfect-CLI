require_relative '../test_helper'

class TestListingProjects < MiniTest::Unit::TestCase
  include DatabaseCleaner

  def test_listing_when_there_are_no_projects
    assert Project.all.empty?
    actual = `ruby futureperfect list`
    assert_equal "", actual
  end

  def test_listing_multiple_projects
    Project.create(name: 'foo')
    Project.create(name: 'bar')
    actual = `ruby futureperfect list`
    expected = <<EOS
1. foo
2. bar
EOS
    assert_equal expected, actual
  end

  def test_projects_are_listed_in_order_of_least_recently_worked
    Project.create(name: 'foo', last_worked_at: 2.days.ago)
    Project.create(name: 'bar', last_worked_at: 1.days.ago)
    Project.create(name: 'grille', last_worked_at: Time.now)
    Project.create(name: 'never', last_worked_at: nil)
    actual = `ruby futureperfect list`
    expected = <<EOS
1. never
2. foo
3. bar
4. grille
EOS
    assert_equal expected, actual
  end
end
