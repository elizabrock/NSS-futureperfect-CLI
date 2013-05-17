class Project < ActiveRecord::Base
  validates_uniqueness_of :name, message: "must be unique"
end
