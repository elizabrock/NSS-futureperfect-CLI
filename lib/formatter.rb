module Formatter
  @@output = []
  @@first_draw = true

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
    "\e[#{color}m#{text}"
  end

  def ding!
    puts BELL
  end

  def redraw is_final_drawing = false
    # move our command prompt to the top of the terminal window, by printing
    # enough newlines to move it up there.
    if @@first_draw
      @@first_draw = false
      print "\n" * (terminal_height - 2)
    end

    # move our cursor to the top of the terminal window
    (terminal_height - 1).times { backtrack_line }

    print "\n" + @@output.join("\n")

    if is_final_drawing
      print "\n" # So the prompt ends up on a fresh new line
    else
      fill_lines = (terminal_height - @@output.size - 2)
      print "\n\e[K" * fill_lines
    end
  end

  def add_line text
    @@output << text
    redraw
  end

  def replace_line replacement_text
    @@output[@@output.length - 1] = replacement_text
    redraw
  end

  def backtrack_line
    print "\e[1A"
  end

  # "\e[1G"  go to beginning of line
  # "\e[K" erase_to_line_end
  # "\e[1D" moves cursor left
  # "\e[1C" moves cursor right

  def terminal_height
    `tput lines`.to_i
  end
end
