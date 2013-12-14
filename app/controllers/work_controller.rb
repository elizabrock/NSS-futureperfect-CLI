require 'continuation'

class WorkController < ApplicationController
  def start continue_indefinitely = true
    quit_cc = nil
    quit = !callcc { |continuation| quit_cc = continuation }
    if quit
      out.puts colorize("Done!", BLUE)
      return
    end

    if Project.workable.empty?
      exit_with "You must enter a project before you can start working", quit_cc
    end

    loop {
      work_repl quit_cc
      quit_cc.call unless continue_indefinitely

      if Project.workable.empty?
        exit_with "All your work is done.  Goodbye!", quit_cc
      else
        set_instructions "Do you wish to continue? Press any key to continue or 'q' to quit"
        input = STDIN.gets
        quit_cc.call if input.include? 'q'
      end
    }
  end

  private

  def default_instructions
    "(q)uit, (s)kip, (n)ext, (d)one, (p)ause"
  end

  def work_repl quit_cc
    next_project_cc = nil
    callcc { |continuation| next_project_cc = continuation }
    work_project! next_project, next_project_cc, quit_cc
  end

  def work_project! project, next_project_cc, quit_cc
    switch_to_project project.name
    set_instructions(default_instructions)

    input_continuation = nil
    input = callcc { |continuation| input_continuation = continuation }
    process_input_for input, project, next_project_cc, quit_cc

    project.countdown(params[:fast]).countdown_with do
      FuturePerfect.check_for_input input_continuation
    end
    project.stop_working!
  end

  def process_input_for input, project, next_project_cc, quit_cc
    return unless input.is_a? String
    erase_input
    if input.start_with? 'q'
      exit_with "Quitting #{project.name}", quit_cc
    elsif input.start_with? 's'
      set_status "Skipping #{project.name}"
      project.stop_working! skipped: true
      next_project_cc.call
    elsif input.start_with? 'n'
      set_status "Done with #{project.name} early"
      project.stop_working! skipped: false
      next_project_cc.call
    elsif input.start_with? 'd'
      set_status "Done with #{project.name} forever!"
      project.stop_working! forever: true
      next_project_cc.call
    elsif input.start_with? 'a'
      project_name = input.strip.gsub(/^add /, '')
      project = Project.new(name: project_name)
      if project.save
        set_status("#{project.name} has been added!")
        set_status("")
      else
        set_status("#{project.errors.full_messages.join(", ")}")
        set_status("")
      end
    elsif input.start_with? 'p'
      if project.countdown.paused?
        set_status "Resuming.."
        set_instructions default_instructions
        set_status ""
      else
        set_status "Paused.."
        set_instructions "Press 'q' to quit, or 'p' to resume"
      end
      project.countdown.toggle_pause!
    else
      set_status "Command '#{input.strip}' is not supported", MAGENTA
      set_status ""
    end
  end

  def next_project
    if params[:project]
      next_project = Project.find_by_name(params[:project][:name])
      params.delete(:project)
    end
    next_project || Project.workable.first
  end
end
