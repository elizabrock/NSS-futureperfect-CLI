require_relative '../test_helper'

describe Countdown do
  RED     = 31 
  GREEN   = 32 
  YELLOW  = 33
  # notice that this does not include DatabaseCleaner, since this test doesn't
  # hit the database at all

  # Additionally, I wouldn't typically test private methods this much or in
  # this way.  However, testing Countdown.for is impractical, so I am focusing
  # on breaking it out into testable private methods.
  describe "choose_color" do
    describe "when less than 10% of time remains" do
      it "should return red" do
        countdown = Countdown.new(1)
        assert_equal RED, countdown.send(:choose_color, 4)
      end
    end
    describe "when more than 10% and less than 20% of time remains" do
      it "should return yellow" do
        countdown = Countdown.new(1)
        assert_equal YELLOW, countdown.send(:choose_color, 9)
      end
    end
    describe "when more than 20% of time remains" do
      it "should return green" do
        countdown = Countdown.new(1)
        assert_equal GREEN, countdown.send(:choose_color, 50)
      end
    end
    describe "when there is 0 time" do
      it "should return red" do
        countdown = Countdown.new(1)
        assert_equal RED, countdown.send(:choose_color, 0)
      end
    end
  end

  describe "format_time" do
    before do
      @countdown = Countdown.new(0)
    end
    describe "when the time is 0" do
      it "should be 00:00:00" do
        assert_equal "00:00:00", @countdown.send(:format_time, 0)
      end
    end
    describe "when the time is " do
      it "should be 103:15:55" do
        assert_equal "103:15:55", @countdown.send(:format_time, 371755)
      end
    end
  end
end
