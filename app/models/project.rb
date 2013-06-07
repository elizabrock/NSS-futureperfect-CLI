class Project < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, message: "must be unique"

  default_scope order("last_worked_at ASC, id ASC")
  scope :skipped, lambda{ where("skip_until > ?", Time.now) }
  scope :workable, lambda{ where("skip_until IS NULL OR skip_until < ?", Time.now) }

  def process_nexted!
    self.minutes_to_work -= 1
    self.last_worked_at = Time.now
    save!
  end

  def process_skipped!
    self.skip_until = Date.today + 1
    save!
  end

  def process_worked!
    self.minutes_to_work += 1
    self.last_worked_at = Time.now
    save!
  end
end
