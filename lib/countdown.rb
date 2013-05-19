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

    while Time.now < end_time
      time_remaining = end_time - Time.now
      current_status = colorize( format_time(time_remaining), choose_color(time_remaining))

      clear_line
      print current_status

      STDOUT.flush
      break if repl_quit?
    end
    puts colorize("Done!", BLUE)
    ding!
  end

  private

  # http://stackoverflow.com/questions/946738/detect-key-press-non-blocking-w-o-getc-gets-in-ruby
  def repl_quit?
    # wait 1 sec for user input from STDIN
    result = IO.select([STDIN], nil, nil, 1)
    return false unless result && (result.first.first == STDIN)

    # We're trying to get rid of the stray letter from
    # the command the user typed in:
    backtrack_line
    move_cursor_right 8
    erase_to_line_end

    input = STDIN.readline #This comes with a newline attached
    if input.include? 'q'
      puts "\nQuitting.."
      true
    else #some other command..
      print  clear_line
      STDOUT.flush
      false
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
