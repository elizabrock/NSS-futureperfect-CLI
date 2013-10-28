module Formatter
  @@out = Kernel
  @@project_name = ""
  @@time_remaining = ""
  @@status = ""
  @@instructions = ""
  @@first_project = true

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
  # "\033[<L>;<C>f" position the cursor a Line and Column
  # "\e[1A"  go up a line
  # "\e[1G"  go to beginning of line
  # "\e[K" erase_to_line_end
  # "\e[1D" moves cursor left
  # "\e[1C" moves cursor right

  def switch_to_project(name)
    unless @@project_name.blank?
      out.print "-----\n"
    end
    out.print "\n" * 4
    @@project_name = colorize(name, GREEN)
    @@time_remaining = "-"
    @@status = "-"
    @@instructions = "-"
    draw
  end

  def set_instructions instructions, color = BLUE
    # # Makes it easier for the tests to see the instructions
    @@instructions = colorize(instructions, color)
    draw
  end

  def set_status status, color = BLACK
    @@status = colorize(status, color)
    draw
    sleep 1 unless test_env?
  end

  def set_time_remaining time_remaining, color
    @@time_remaining = colorize(time_remaining, color)
    draw
  end

  def exit_with message, quit_cc
    set_instructions ""
    out.puts message
    quit_cc.call
  end

  def erase_input
    out.print "\e[1G" # Go to beginning of line
    out.print "\e[K"  # Erase current line
    out.print "\e[1A" # Go up 1 lines
  end

  def draw
    unless test_env?
      out.print "\e[1A" * 4 # Go up 5 lines, which is 4 lines of text plus one of input (the last newline)
    end
    [@@project_name, @@time_remaining, @@status, @@instructions].each do |replacement_text|
      out.print "\e[1G"     # Go to beginning of line
      out.print "\e[K"      # Erase current line
      out.print replacement_text + "\n"
    end
  end

  # Used a.la carte, outside of project printing
  def add_line text, color = nil
    # prepend = test_env? ? " +" : ""
    prepend = ""
    out.print colorize("#{prepend}#{text.rstrip}\n", color)
  end

  def ding!
    out.puts BELL
  end

  private

  def colorize text, color
    return text unless color
    # Set color, add text, unset color
    "\e[#{color}m#{text}\e[0m"
  end

  def out
    @@out
  end
end
