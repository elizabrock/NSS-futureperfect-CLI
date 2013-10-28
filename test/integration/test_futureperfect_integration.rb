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
    # Adding the coveralls output to my test so I can check something out.
    expected = <<EOS
 #   project            time  last worked
---  -----------------  ----  -----------
 1.  foo                 30   
 2.  bar                 30   

 #   [recently worked]  time  last worked
---  -----------------  ----  -----------
EOS
    assert_equal expected, strip_control_characters_and_excesses(actual)
  end

  def test_remove_project
    Project.create( name: 'only child')
    `ruby futureperfect remove "only child"`
    assert Project.all.empty?
  end

  def test_work_on_projects
    Project.create(name: 'foo', last_worked_at: 3.days.ago)
    Project.create(name: 'bar', last_worked_at: 2.days.ago)
    Project.create(name: 'grille', last_worked_at: Time.now)
    Project.create(name: 'never', last_worked_at: nil, minutes_to_work: 0)
    actual = run_and_q "ruby futureperfect start"
    assert_includes actual, "never"
    actual = run_and_q "ruby futureperfect start"
    assert_includes actual, "foo"
    refute_includes actual, "never"
  end

  def test_work_on_particular_projects
    Project.create(name: 'foo', last_worked_at: 3.days.ago)
    Project.create(name: 'bar', last_worked_at: 2.days.ago)
    Project.create(name: 'grille', last_worked_at: Time.now)
    Project.create(name: 'never', last_worked_at: nil, minutes_to_work: 0)
    actual = run_and_q "ruby futureperfect start bar"
    assert_includes actual, "bar"
    # On the next run, continues where we left off
    actual = run_and_q "ruby futureperfect start"
    refute_includes actual, "bar"
    assert_includes actual, "never"
  end
end
