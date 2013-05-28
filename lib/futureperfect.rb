require 'active_support/inflector'

include ActiveSupport::Inflector

class FuturePerfect
  def self.check_for_input continuation
    # wait 1 sec for user input from STDIN
    result = IO.select([STDIN], nil, nil, 1)
    return unless result && (result.first.first == STDIN)

    input = STDIN.readline #readline comes with the newline attached
    continuation.call input
  end

  def self.route( command, project_name)
    # This is a router:
    routes = { "add" => { controller: :projects, action: :create },
              "list" => { controller: :projects, action: :index },
              "remove" => { controller: :projects, action: :destroy },
              "start" => { controller: :work, action: :work_repl } }

    params = { command: command }
    if project_name
      params[:project] = { name: project_name }
    end

    if route = routes[command]
      controller_name = "#{route[:controller]}_controller"
      controller_class = constantize(classify(controller_name))
      controller = controller_class.new(params)
      controller.send route[:action]
    else
      unless command == "help"
        puts "FuturePerfect does not (yet?) support the '#{command}' command.\n\n"
      end
      puts <<EOS
Currently supported commands are:
* futureperfect list
* futureperfect add <project_name>
* futureperfect remove <project_name>
* futureperfect start

See the README for more details
EOS
    end
  end
end
