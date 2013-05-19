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

    print colorize( format_time(total_time_in_seconds), choose_color(total_time_in_seconds))
    print fill

    while Time.now < end_time
      time_remaining = end_time - Time.now
      print backtrack
      print colorize( format_time(time_remaining), choose_color(time_remaining))
      print fill
      sleep 1
    end
    print backtrack
    puts colorize("Done!", BLUE)
    ding!
  end

  private

  def terminal_height
    `tput lines`.to_i
  end

  def backtrack
     "\e[#{terminal_height - 2}A" + " " * 8 + "\e[#{8}D"
  end

  def fill
    output = ""
    (terminal_height - 2).times do
      output <<  "\n"
    end
    output
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
