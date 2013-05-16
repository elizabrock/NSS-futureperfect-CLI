require 'test_helper'

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
end
