require_relative '../test_helper'

describe "WorkController" do
  include DatabaseCleaner

  let(:stdout){ StringIO.new }
  
  before do
    Formatter.output_to stdout
    Formatter.reset!
  end

  describe "#start" do
    let(:controller){ WorkController.new( {} ) }
    describe "when there are no projects" do
      it "gives an error message" do
        assert Project.all.empty?
        controller.start
        assert_includes clean_output_from(stdout), "You must enter a project before you can start working"
      end
    end
    describe "when there are projects" do
      before do
        Project.create(name: 'foo', last_worked_at: 2.days.ago)
        Project.create(name: 'bar', last_worked_at: 1.days.ago)
        Project.create(name: 'grille', last_worked_at: Time.now)
        @next_project = Project.create(name: 'never', last_worked_at: nil, minutes_to_work: 0)
        controller.start false
      end
      it "starts the least recently worked project" do
        assert_includes clean_output_from(stdout), "never"
      end
      it "sets the project to the correct updated last_worked_at" do
        @next_project.reload # reloads the project from the database
        assert_in_delta Time.now.to_i, @next_project.last_worked_at.to_i, 5
      end
    end
  end
end
