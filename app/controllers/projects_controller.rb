class ProjectsController

  def initialize params, stdout = Kernel
    @params = params
    @out = stdout
  end

  def index
    projects = Project.all
    projects.each_with_index do |project, i|
      @out.puts "#{i+1}. #{project.name}"
    end
  end

  def create
    project = Project.new(params[:project])
    if project.save
      @out.puts "Success!"
    else
      @out.puts "Failure :( #{project.errors.full_messages.join(", ")}"
    end
  end

  def destroy
    matching_projects = Project.where(name: params[:project][:name]).all
    if matching_projects.empty?
      @out.puts "Project could not be found"
    else
      matching_projects.each do |project|
        project.destroy
      end
      @out.puts "Success!"
    end
  end

  private

  def params
    @params
  end
end
