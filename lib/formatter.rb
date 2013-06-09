module Formatter
  @@out = Kernel
  @@output = []
  @@longest_output = 0
  @@first_draw = true
  @@instructions = ""

  def self.output_to out
    @@out = out
  end

  BLACK   = 30
  RED     = 31
  GREEN   = 32
  YELLOW  = 33
  BLUE    = 34
  MAGENTA = 35
  CYAN    = 36
  WHITE   = 37

  BELL = "\a"

  def colorize text, color
    return text unless color
    # Set color, add text, unset color
    "\e[#{color}m#{text}\e[0m"
  end

  def ding!
    out.puts BELL
  end

  # "\033[<L>;<C>f" position the cursor a Line and Column
  # "\e[1A"  go up a line
  # "\e[1G"  go to beginning of line
  # "\e[K" erase_to_line_end
  # "\e[1D" moves cursor left
  # "\e[1C" moves cursor right
  def redraw
    # move our command prompt to the top of the terminal window, by printing
    # enough newlines to move it up there.
    if @@first_draw
      @@first_draw = false
      out.print "\n" * screen_height
    end

    # move to top of screen
    out.print "\033[2;0f"

    # print each line of the output buffer by clearing the line, printing the
    # line, then moving to the next line.
    @@output.each_with_index do |line, i|
      preamble = (i == 0 ) ? "" : "\n"
      out.print "#{preamble}\e[K" + line
    end
    # print a blank line and then the instructions
    out.print "\n\e[K\n\e[K" + @@instructions

    # make sure that any typed input (which goes on the line after what we've
    # previously printed) is wiped out
    out.print "\n\e[K"
  end

  def reset_with_message message, opts = {skip_pause: false}
    opts[:color] ||= MAGENTA
    # Added for clarity in test output
    add_line "-resetting output-" if test_env?
    replace_line message, opts[:color]
    unless test_env?
      sleep 1 unless opts[:skip_pause]
      @@instructions = ""
      # blank the screen
      @@output = @@output.map{|line| ""}
      redraw
      # clear buffer
      @@output = []
    end
  end

  def add_line text, color = nil
    prepend = test_env? ? " +" : ""
    @@output << colorize("#{prepend}#{text}", color)
    redraw
  end

  def replace_line replacement_text, color = nil
    if @@output.empty?
      add_line replacement_text, color
      return
    end
    if test_env?
      # This makes easier to read test output
      @@output << "^= #{replacement_text}"
    else
      @@output[@@output.length - 1] = colorize(replacement_text, color)
    end
    redraw
  end

  def set_instructions instructions, color = BLUE
    # Makes it easier for the tests to see the instructions
    add_line instructions if test_env?
    @@instructions = colorize(instructions, color)
    redraw
  end

  def screen_height
    @screen_height ||= (`tput lines`.to_i - 2)
  end

  private

  def out
    @@out
  end
end
