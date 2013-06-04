class ProjectsController

  def initialize params, stdout = Kernel
    @params = params
    @out = stdout
  end

  def index
    projects = Project.all
    return if projects.empty?
    project_name_lengths = projects.collect{ |p| p.name.length + 4 }
    project_name_lengths << 9 # minimum length
    projects_width = project_name_lengths.max
    @out.puts " #   " + "project".ljust(projects_width) + "  time  last worked"
    @out.puts "---  " + ("-" * projects_width)             + "  ----  -----------"
    projects.each_with_index do |project, i|
      position = (i + 1).to_s.rjust(2)
      name = project.name.ljust(projects_width)
      last_worked = project.last_worked_at.try(:strftime, "%m/%d %H:%M")

      @out.puts "#{position}.  #{name}   #{project.minutes_to_work}   #{last_worked}"
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
