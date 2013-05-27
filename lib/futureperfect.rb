require 'active_support/inflector'

class FuturePerfect
  include ActiveSupport::Inflector

  def initialize
    database = ENV['FP_ENV'] || 'development'
    connect_to database
  end

  def execute( command, project_name)
    # This is a router:
    routes = { "add" => { controller: :projects, action: :create },
              "list" => { controller: :projects, action: :index },
              "remove" => { controller: :projects, action: :destroy },
              "start" => { controller: :work, action: :work } }

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
