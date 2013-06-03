class WorkController
  include Formatter

  def initialize params, stdout = Kernel
    @params = params
    @out = stdout
    Formatter.output_to stdout
  end

  def work_repl
    if Project.count < 1
      @out.puts "You must enter a project before you can start working"
      return
    end

    next_project_cc = nil
    last_project = nil
    input = callcc { |continuation| next_project_cc = continuation }

    last_project.try(:decrease_time_budget!)
    last_project = next_project
    work_project! last_project, next_project_cc
  end

  def work_project! project, next_project_cc
    project.update_attribute(:last_worked_at, Time.now)
    countdown = Countdown.new(project.minutes_to_work)

    add_line colorize(project.name, GREEN)
    add_line "Starting" #This line will be overwritten

    input_continuation = nil
    input = callcc { |continuation| input_continuation = continuation }
    process_input_for input, countdown, next_project_cc

    countdown.countdown_with do
      FuturePerfect.check_for_input input_continuation
    end
    project.increase_time_budget!
  end

  def process_input_for input, countdown, next_project_cc
    return unless input.is_a? String
    if input.include? 'q'
      countdown.stop!
    elsif input.include? 'n'
      next_project_cc.call
    elsif input.include? 'p'
      countdown.toggle_pause!
    else
      # some other command that isn't implemented, ignore it.
      add_line "Command '#{input.strip}' is not supported"
      add_line "Cont..."
    end
  end

  private

  def next_project
    if params[:project]
      next_project = Project.find_by_name(params[:project][:name])
      params.delete(:project)
    end
    next_project || Project.first
  end

  def params
    @params
  end
end
