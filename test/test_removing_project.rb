require 'test_helper'

class TestRemovingProject < MiniTest::Unit::TestCase
  include DatabaseCleaner

  def test_remove_only_project
    Project.create( name: 'only child')
    `ruby futureperfect remove "only child"`
    assert Project.all.empty?
  end

  def test_remove_particular_project
    Project.create( name: 'a')
    Project.create( name: 'b')
    Project.create( name: 'c')
    assert !Project.where( name: 'b').all.empty?
    `ruby futureperfect remove b`
    assert Project.where( name: 'b').all.empty?
    # assert_equal 2, Project.count
  end

  def test_remove_particular_project_doesnt_remove_all
    assert Project.all.empty?
    Project.create( name: 'a')
    Project.create( name: 'b')
    Project.create( name: 'c')
    assert !Project.where( name: 'b').all.empty?
    `ruby futureperfect remove b`
    assert_equal 2, Project.count
  end
end
