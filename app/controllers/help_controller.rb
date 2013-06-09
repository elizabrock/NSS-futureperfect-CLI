class HelpController < ApplicationController
  def help
    add_line "Currently supported commands are:"
    add_line "* futureperfect list"
    add_line "* futureperfect add <project_name>"
    add_line "* futureperfect remove <project_name>"
    add_line "* futureperfect start"
    add_line ""
    add_line "See the README for more details"
  end

  def unknown_command
    add_line "FuturePerfect does not support the '#{params[:command]}' command.\n\n"
    self.help
  end
end
