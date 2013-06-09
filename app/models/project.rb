class Project < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, message: "must be unique"

  default_scope order("completed_at ASC, last_worked_at ASC, id ASC")

  scope :finished,   where("completed_at IS NOT NULL")
  scope :unfinished, where("completed_at IS NULL")

  scope :currently_skipped,     lambda{ where("skip_until > ?", Time.now) }
  scope :not_currently_skipped, lambda{ where("skip_until IS NULL OR skip_until <= ?", Time.now) }

  scope :unworkable, lambda{ unfinished.where("skip_until > ? OR last_worked_at >= ?", Time.now, Date.today - 1) }
  scope :workable,   lambda{ unfinished.not_currently_skipped.where("last_worked_at IS NULL OR last_worked_at < ?", Date.today - 1) }

  def complete?
    !!completed_at
  end

  def countdown
    @countdown ||= Countdown.new(minutes_to_work)
  end

  def stop_working! opts = {}
    if opts[:forever]
      complete
    elsif opts[:skipped]
      process_skipped
    else
      process_worked
    end
    save!
  end

  private

  def complete
    self.completed_at = Time.now
  end

  def process_skipped
    self.skip_until = Date.today + 1
  end

  def process_worked
    time_adjustment = (countdown.done?) ? 1 : -1
    self.minutes_to_work += time_adjustment
    self.last_worked_at = Time.now
  end
end
