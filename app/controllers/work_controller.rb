require 'continuation'

class WorkController
  include Formatter

  def initialize params, stdout = Kernel
    @params = params
    @out = stdout
    Formatter.output_to stdout
  end

  def start continue_indefinitely = true
    if Project.workable.empty?
      add_line "You must enter a project before you can start working"
      return
    end

    quit_cc = nil
    quit = !callcc { |continuation| quit_cc = continuation }
    if quit
      add_line colorize("Done!", BLUE)
      return
    end

    loop {
      work_repl quit_cc
      quit_cc.call unless continue_indefinitely

      add_line "Do you wish to continue? Press any key to continue or 'q' to quit"
      input = STDIN.gets
      quit_cc.call if input.include? 'q'
    }
  end

  private

  def work_repl quit_cc
    next_project_cc = nil
    callcc { |continuation| next_project_cc = continuation }
    work_project! next_project, next_project_cc, quit_cc
  end

  def work_project! project, next_project_cc, quit_cc
    add_line colorize(project.name, GREEN)
    add_line "This line will be overwritten" #This line will be overwritten

    input_continuation = nil
    input = callcc { |continuation| input_continuation = continuation }
    process_input_for input, project, next_project_cc, quit_cc

    project.countdown.countdown_with do
      FuturePerfect.check_for_input input_continuation
    end
    project.stop_working!
  end

  def process_input_for input, project, next_project_cc, quit_cc
    return unless input.is_a? String
    if input.include? 'q'
      reset_with_message "Quitting #{project.name}", :no_pause
      project.stop_working! skipped: true
      quit_cc.call
    elsif input.include? 's'
      reset_with_message "Skipping #{project.name}"
      project.stop_working! skipped: true
      next_project_cc.call
    elsif input.include? 'n'
      reset_with_message "Done with #{project.name} early"
      project.stop_working! skipped: false
      next_project_cc.call
    elsif input.include? 'p'
      replace_line "Paused.. Press 'q' to quit, or 'p' to resume"
      project.countdown.toggle_pause!
    else
      replace_line "Command '#{input.strip}' is not supported"
      sleep 1
    end
  end

  def next_project
    if params[:project]
      next_project = Project.find_by_name(params[:project][:name])
      params.delete(:project)
    end
    next_project || Project.workable.first
  end

  def params
    @params
  end
end
