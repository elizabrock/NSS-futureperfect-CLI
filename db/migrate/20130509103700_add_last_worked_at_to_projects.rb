class AddLastWorkedAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :last_worked_at, :datetime
  end
end
