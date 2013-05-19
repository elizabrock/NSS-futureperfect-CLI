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
end
