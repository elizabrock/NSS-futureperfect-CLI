require_relative '../test_helper'

describe "ProjectsController" do
  include DatabaseCleaner

  let(:stdout){ StringIO.new }

  before do
    Formatter.output_to stdout
  end

  describe "#index" do
    let(:controller){ ProjectsController.new( {} ) }
    describe "when there are no projects" do
      it "outputs an empty string" do
        assert Project.all.empty?
        controller.index
        assert_equal "", clean_output_from(stdout)
      end
    end
    describe "when there are multiple projects" do
      before do
        Project.create(name: 'foo')
        Project.create(name: 'bar')
      end
      it "outputs the full list" do
        controller.index
        expected = <<EOS
 #   project            time  last worked
---  -----------------  ----  -----------
 1.  foo                 30
 2.  bar                 30

 #   [recently worked]  time  last worked
---  -----------------  ----  -----------
EOS
        assert_equal expected, clean_output_from(stdout)
      end
    end
    describe "when some of the projects have been worked on" do
      before do
        Project.create(name: 'foo', last_worked_at: Date.parse("2013/05/01 00:00:00"))
        Project.create(name: 'bar', last_worked_at: Date.parse("2013/05/02 00:00:00"))
        Project.create(name: 'grille', last_worked_at: Date.parse("2013/05/03 00:00:00"))
        Project.create(name: 'never', last_worked_at: nil)
      end
      it "lists them in order of least recently worked" do
        expected = <<EOS
 #   project            time  last worked
---  -----------------  ----  -----------
 1.  never               30
 2.  foo                 30   05/01 00:00
 3.  bar                 30   05/02 00:00
 4.  grille              30   05/03 00:00

 #   [recently worked]  time  last worked
---  -----------------  ----  -----------
EOS
        controller.index
        assert_equal expected, clean_output_from(stdout)
      end
    end
    describe "when some of the projects have been skipped" do
      before do
        Project.create(name: 'foo skip', last_worked_at: Date.parse("2013/05/01 00:00:00"), skip_until: (Date.today + 3))
        Project.create(name: 'foo is ready', last_worked_at: Date.parse("2013/04/29 00:00:00"), skip_until: (Date.today - 1))
        Project.create(name: 'foo', last_worked_at: Date.parse("2013/05/01 00:00:00"))
        Project.create(name: 'bar', last_worked_at: Date.parse("2013/05/02 00:00:00"))
        Project.create(name: 'grille', last_worked_at: Date.today.beginning_of_day)
        Project.create(name: 'never', last_worked_at: nil)
        Project.create(name: 'never ever', last_worked_at: nil, skip_until: (Time.now + (60*60)))
      end
      it "should place those items last unless they are ready to be worked" do
        today = Date.today.beginning_of_day.try(:strftime, "%m/%d %H:%M")
        expected = <<EOS
 #   project            time  last worked
---  -----------------  ----  -----------
 1.  never               30
 2.  foo is ready        30   04/29 00:00
 3.  foo                 30   05/01 00:00
 4.  bar                 30   05/02 00:00

 #   [recently worked]  time  last worked
---  -----------------  ----  -----------
 1.  never ever          30   (skipped)
 2.  foo skip            30   (skipped)
 3.  grille              30   #{today}
EOS
        controller.index
        assert_equal expected, clean_output_from(stdout)
      end
    end
    describe "when some of the projects have been completed" do
      before do
        Project.create(name: 'foo skip', last_worked_at: Date.parse("2013/05/01 00:00:00"), skip_until: (Date.today + 3))
        Project.create(name: 'foo is ready', last_worked_at: Date.parse("2013/04/29 00:00:00"), skip_until: (Date.today - 1))
        Project.create(name: 'foo', last_worked_at: Date.parse("2013/05/01 00:00:00"))
        Project.create(name: 'bar', last_worked_at: Date.parse("2013/05/02 00:00:00"))
        Project.create(name: 'grille', last_worked_at: Date.today.beginning_of_day, completed_at: Time.now)
        Project.create(name: 'never', last_worked_at: nil)
        Project.create(name: 'done never', last_worked_at: nil, completed_at: Date.today - 3)
        Project.create(name: 'never ever', last_worked_at: nil, skip_until: (Time.now + (60*60)))
      end
      it "should place those items last unless they are ready to be worked" do
        today = Date.today.beginning_of_day.try(:strftime, "%m/%d")
        before = (Date.today - 3).beginning_of_day.try(:strftime, "%m/%d")
        expected = <<EOS
 #   project            time  last worked
---  -----------------  ----  -----------
 1.  never               30
 2.  foo is ready        30   04/29 00:00
 3.  foo                 30   05/01 00:00
 4.  bar                 30   05/02 00:00

 #   [recently worked]  time  last worked
---  -----------------  ----  -----------
 1.  never ever          30   (skipped)
 2.  foo skip            30   (skipped)

 #   [completed projects]  finished on
---  -----------------  -----------
 1.  done never          #{before}
 2.  grille              #{today}
EOS
        controller.index
        assert_equal expected, clean_output_from(stdout)
      end
    end
  end

  describe "#create" do
    describe "success" do
      let(:controller){ ProjectsController.new( { project: { name: 'foo' } } ) }

      it "creates a new project" do
        expected_count = Project.count + 1
        controller.create
        new_count = Project.count
        assert_equal expected_count, new_count
      end

      it "creates the project with the correct name" do
        controller.create
        assert_equal 'foo', Project.last.name
      end
    end

    describe "duplicate" do
      let(:controller){ ProjectsController.new( { project: { name: 'foo' } } ) }

      before do
        Project.create( name: 'foo' )
      end

      it "does not create projects with duplicate names" do
        expected_count = Project.count
        controller.create
        assert_equal expected_count, Project.count
      end
      it "returns an error for duplicate names" do
        controller.create
        assert_includes clean_output_from(stdout), 'Name must be unique'
      end
    end

    describe "blank name" do
      let(:controller){ ProjectsController.new( { project: { name: nil } } ) }

      it "returns an error message" do
        controller.create
        assert_includes clean_output_from(stdout), "Name can't be blank"
      end
    end
  end

  describe "#destroy" do
    describe "removing the only project" do
      let(:controller){ ProjectsController.new( { project: { name: 'only child' } } ) }
      before do
        Project.create( name: 'only child')
        controller.destroy
      end
      it "should be successful" do
        assert Project.all.empty?
      end
    end
    describe "attempting to remove a project that does not exist" do
      let(:controller){ ProjectsController.new( { project: { name: "doesn't exist" } } ) }
      before do
        Project.create( name: 'exists')
        controller.destroy
      end
      it "should return an error" do
        assert_includes clean_output_from(stdout), "Project could not be found"
      end
    end
    describe "removing a particular project amongst many" do
      let(:controller){ ProjectsController.new( { project: { name: 'b' } } ) }
      before do
        Project.create( name: 'a')
        Project.create( name: 'b')
        Project.create( name: 'c')
        controller.destroy
      end
      it "removes that project" do
        assert Project.where( name: 'b').all.empty?
      end
      it "does not remove the other projects" do
        assert_equal 2, Project.count
      end
    end
  end
end
