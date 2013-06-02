class WorkController
  include Formatter

  def initialize params, stdout = Kernel
    @params = params
    @out = stdout
    Formatter.output_to stdout
  end

  def work_repl
    next_project_cc = nil
    input = callcc { |continuation| next_project_cc = continuation }
    work_next_project! next_project_cc
  end

  def work_next_project! next_project_cc
    project = next_project
    if project
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
    else
      @out.puts "You must enter a project before you can start working"
    end
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
