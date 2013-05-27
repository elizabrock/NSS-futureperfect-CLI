class WorkController
  include Formatter

  def initialize params, stdout = Kernel
    @params = params
    @out = stdout
    Formatter.output_to stdout
  end

  def work
    project = Project.first
    if project
      project.update_attribute(:last_worked_at, Time.now)
      add_line colorize("#{project.name}", GREEN)
      Countdown.for(project.minutes_to_work)
    else
      @out.puts "You must enter a project before you can start working"
    end
  end

  private

  def params
    @params
  end
end
