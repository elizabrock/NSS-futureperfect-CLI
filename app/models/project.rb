class Project < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, message: "must be unique"
  default_scope order("last_worked_at ASC, id ASC")

  def minutes_to_work
    ENV['FP_ENV'] == 'test' ? 1 : 30
  end
end
