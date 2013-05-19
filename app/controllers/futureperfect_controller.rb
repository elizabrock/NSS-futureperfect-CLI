class FuturePerfectController

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

  private

  def params
    @params
  end
end
