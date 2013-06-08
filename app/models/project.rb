class Project < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, message: "must be unique"

  default_scope order("last_worked_at ASC, id ASC")
  scope :skipped, lambda{ where("skip_until > ?", Time.now) }
  scope :workable, lambda{ where("skip_until IS NULL OR skip_until < ?", Time.now) }

  def countdown
    @countdown ||= Countdown.new(minutes_to_work)
  end

  def stop_working! opts = {}
    # countdown.stop!
    if opts.has_key?(:skipped) and opts[:skipped]
      process_skipped!
    else
      process_worked!
    end
    save!
  end

  private

  def process_skipped!
    self.skip_until = Date.today + 1
  end

  def process_worked!
    time_adjustment = (countdown.done?) ? 1 : -1
    self.minutes_to_work += time_adjustment
    self.last_worked_at = Time.now
  end
end
