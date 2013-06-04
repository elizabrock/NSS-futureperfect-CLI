require_relative '../test_helper'

describe "ProjectsController" do
  include DatabaseCleaner

  let(:stdout){ StringIO.new }
  
  describe "#index" do
    let(:controller){ ProjectsController.new( {}, stdout ) }
    describe "when there are no projects" do
      it "outputs an empty string" do
        assert Project.all.empty?
        controller.index
        stdout.rewind
        assert_equal "", stdout.read
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
 #   project    time  last worked
---  ---------  ----  -----------
 1.  foo         30   
 2.  bar         30   
EOS
        stdout.rewind
        assert_equal expected, stdout.read
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
 #   project     time  last worked
---  ----------  ----  -----------
 1.  never        30   
 2.  foo          30   05/01 00:00
 3.  bar          30   05/02 00:00
 4.  grille       30   05/03 00:00
EOS
        controller.index
        stdout.rewind
        assert_equal expected, stdout.read
      end
    end
  end

  describe "#create" do
    describe "success" do
      let(:controller){ ProjectsController.new( { project: { name: 'foo' } }, stdout ) }

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
      let(:controller){ ProjectsController.new( { project: { name: 'foo' } }, stdout ) }

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
        stdout.rewind
        assert_includes stdout.read, 'Name must be unique'
      end
    end

    describe "blank name" do
      let(:controller){ ProjectsController.new( { project: { name: nil } }, stdout ) }

      it "returns an error message" do
        controller.create
        stdout.rewind
        assert_includes stdout.read, "Name can't be blank"
      end
    end
  end

  describe "#destroy" do
    describe "removing the only project" do
      let(:controller){ ProjectsController.new( { project: { name: 'only child' } }, stdout ) }
      before do
        Project.create( name: 'only child')
        controller.destroy
      end
      it "should be successful" do
        assert Project.all.empty?
      end
    end
    describe "attempting to remove a project that does not exist" do
      let(:controller){ ProjectsController.new( { project: { name: "doesn't exist" } }, stdout ) }
      before do
        Project.create( name: 'exists')
        controller.destroy
      end
      it "should return an error" do
        stdout.rewind
        assert_includes stdout.read, "Project could not be found"
      end
    end
    describe "removing a particular project amongst many" do
      let(:controller){ ProjectsController.new( { project: { name: 'b' } }, stdout ) }
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
