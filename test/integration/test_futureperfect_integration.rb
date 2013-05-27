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
end
