class FuturePerfectController
  include Formatter

  def initialize params
    @params = params
  end

  def index
    projects = Project.all
    projects.each_with_index do |project, i|
      puts "#{i+1}. #{project.name}"
    end
  end

  def create
    project = Project.new(params[:project])
    if project.save
      puts "Success!"
    else
      puts "Failure :( #{project.errors.full_messages.join(", ")}"
    end
  end

  def destroy
    matching_projects = Project.where(name: params[:project][:name]).all
    matching_projects.each do |project|
      project.destroy
    end
  end

  def work
    project = Project.first
    if project
      project.update_attribute(:last_worked_at, Time.now)
      puts colorize("#{project.name}", GREEN)
      Countdown.for(project.minutes_to_work)
    else
      puts "You must enter a project before you can start working"
    end
  end

  private

  def params
    @params
  end
end
