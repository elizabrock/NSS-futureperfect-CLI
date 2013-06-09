class ProjectsController < ApplicationController
  def index
    projects = Project.all
    return if projects.empty?
    project_name_lengths = projects.collect{ |p| p.name.length + 4 }
    project_name_lengths << 17 # minimum length
    projects_width = project_name_lengths.max

    add_line " #   " + "project".ljust(projects_width) + "  time  last worked"
    add_line "---  " + ("-" * projects_width)          + "  ----  -----------"
    (Project.workable + Project.unworkable).each_with_index do |project, i|
      position = (i + 1).to_s.rjust(2)
      name = project.name.ljust(projects_width)
      worked_at_status = project.last_worked_at.try(:strftime, "%m/%d %H:%M")
      if project.skip_until and project.skip_until > Time.now
        worked_at_status = "(skipped)"
      end

      add_line "#{position}.  #{name}   #{project.minutes_to_work}   #{worked_at_status}"
    end

    finished_projects = Project.finished
    return if finished_projects.empty?

    add_line ""
    add_line " #   " + "completed project".ljust(projects_width) + "  finished on"
    add_line "---  " + ("-" * projects_width)                    + "  -----------"
    finished_projects.each_with_index do |project, i|
      position = (i + 1).to_s.rjust(2)
      name = project.name.ljust(projects_width)
      finished_on = project.completed_at.strftime("%m/%d")
      add_line "#{position}.  #{name}   #{finished_on}"
    end
  end

  def create
    project = Project.new(params[:project])
    if project.save
      add_line "Success!"
    else
      add_line "Failure :( #{project.errors.full_messages.join(", ")}"
    end
  end

  def destroy
    matching_projects = Project.where(name: params[:project][:name]).all
    if matching_projects.empty?
      add_line "Project could not be found"
    else
      matching_projects.each do |project|
        project.destroy
      end
      add_line "Success!"
    end
  end
end
