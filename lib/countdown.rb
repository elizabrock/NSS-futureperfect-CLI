require_relative 'formatter'

class Countdown
  include Formatter

  attr_accessor :total_time_in_seconds

  def self.for total_time_in_minutes
    countdown = Countdown.new(total_time_in_minutes)
    countdown.execute!
  end

  def initialize total_time_in_minutes
    @total_time_in_seconds = total_time_in_minutes * 60
  end

  def execute!
    end_time =  Time.now + total_time_in_seconds

    add_line colorize( format_time(total_time_in_seconds), choose_color(total_time_in_seconds))

    while Time.now < end_time
      time_remaining = end_time - Time.now
      current_status = colorize( format_time(time_remaining), choose_color(time_remaining))

      replace_line current_status
      repl
    end
    add_line colorize("Done!", BLUE)
    redraw :final
    ding!
  end

  private

  def repl
    # wait 1 sec for user input from STDIN
    result = IO.select([STDIN], nil, nil, 1)
    return false unless result && (result.first.first == STDIN)

    input = STDIN.readline #readline comes with the newline attached
    if input.include? 'q'
      add_line "Quitting.."
      redraw :final
      exit
    else
      # some other command that isn't implemented, ignore it.
    end
  end

  def format_time time
    seconds = time % 60
    minutes  = (time / 60) % 60
    hours = time / 3600
    formatted_string = sprintf("%02d:%02d:%02d", hours, minutes, seconds);
  end

  def choose_color seconds_remaining
    percentage_remaining = 0

    if total_time_in_seconds > 0
      percentage_remaining = 100 * seconds_remaining / total_time_in_seconds
    end

    if percentage_remaining > 20
      GREEN
    elsif percentage_remaining > 10
      YELLOW
    else
      RED
    end
  end
end
