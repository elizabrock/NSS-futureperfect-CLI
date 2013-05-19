module Formatter
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

  def clear_line
    # Go to beginning of line, then erase to the end of the line
    print "\e[1G"
    erase_to_line_end
  end

  def erase_to_line_end
    print "\e[K"
  end

  def backtrack_line
    print "\e[1A"
  end

  def move_cursor_left total_characters = 64
    print "\e[#{total_characters}D"
  end

  def move_cursor_right total_characters = 1
    print "\e[#{total_characters}C"
  end
end
