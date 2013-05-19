class Project < ActiveRecord::Base
  validates_uniqueness_of :name, message: "must be unique"
  default_scope order("last_worked_at ASC")
end
