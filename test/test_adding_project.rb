require 'test_helper'

class TestAddingProject < Test::Unit::TestCase
  def test_takes_arguments_and_saves_them
    # start with no projects
    assert_equal Project.count, 0
    # `ruby futureperfect add foo`
    Project.create( name: 'foo' )
    # end up with a 'foo' project
    assert_equal Project.count, 1
  end
end
