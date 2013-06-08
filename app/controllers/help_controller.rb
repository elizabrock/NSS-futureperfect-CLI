class HelpController
  def initialize params, stdout = Kernel
    @params = params
    @out = stdout
  end

  def help
    @out.puts <<EOS
Currently supported commands are:
* futureperfect list
* futureperfect add <project_name>
* futureperfect remove <project_name>
* futureperfect start

See the README for more details
EOS
  end

  def unknown_command
    @out.puts "FuturePerfect does not support the '#{params[:command]}' command.\n\n"
    self.help
  end

  private

  def params
    @params
  end
end
