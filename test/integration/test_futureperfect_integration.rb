require_relative '../test_helper'

class TestFuturePerfectIntegration < MiniTest::Unit::TestCase
  include DatabaseCleaner

  def test_add_creates_project
    `ruby futureperfect add foo`
    assert_equal 'foo', Project.last.name
  end

  def test_list_projects
    Project.create(name: 'foo')
    Project.create(name: 'bar')
    actual = `ruby futureperfect list`
    expected = <<EOS
1. foo
2. bar
EOS
    assert_equal expected, actual
  end

  def test_remove_project
    Project.create( name: 'only child')
    `ruby futureperfect remove "only child"`
    assert Project.all.empty?
  end

  def test_work_on_projects
    Project.create(name: 'foo', last_worked_at: 2.days.ago)
    Project.create(name: 'bar', last_worked_at: 1.days.ago)
    Project.create(name: 'grille', last_worked_at: Time.now)
    Project.create(name: 'never', last_worked_at: nil)
    actual = `ruby futureperfect start`
    assert actual.include?( "never" ), "Should have been 'never', was: '#{actual}'"
    actual = `ruby futureperfect start`
    assert actual.include?( "foo" ), "Should have been 'foo', was: '#{actual}'"
  end
end
