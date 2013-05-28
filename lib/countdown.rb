require_relative 'formatter'
require 'continuation'

class Countdown
  include Formatter

  attr_accessor :total_time_in_seconds

  def self.for total_time_in_minutes
    countdown = Countdown.new(total_time_in_minutes)

    countdown.countdown
  end

  def initialize total_time_in_minutes
    @total_time_in_seconds = total_time_in_minutes * 60
    @end_time =  Time.now + total_time_in_seconds
  end

  def time_remaining
    @end_time - Time.now
  end

  def countdown
    add_line "Starting" #This line will be overwritten
    input_continuation = nil
    input = callcc {|continuation| input_continuation = continuation }
    process input

    until time_remaining <= 0
      tick
      FuturePerfect.check_for_input input_continuation
    end
    output_conclusion
  end

  def tick
    current_status = colorize( format_time(time_remaining), choose_color(time_remaining))
    replace_line current_status
  end

  def output_conclusion
    add_line colorize("Done!", BLUE)
    redraw :final
    ding!
  end

  def process input
    return unless input.is_a? String
    if input.include? 'q'
      @end_time = Time.now
    else
      # some other command that isn't implemented, ignore it.
      add_line "Command '#{input.strip}' is not supported"
      add_line "Cont..."
    end
  end

  private

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
