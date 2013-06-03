class Project < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, message: "must be unique"
  default_scope order("last_worked_at ASC, id ASC")

  def decrease_time_budget!
    self.minutes_to_work -= 1
    save!
  end

  def increase_time_budget!
    self.minutes_to_work += 1
    save!
  end
end
