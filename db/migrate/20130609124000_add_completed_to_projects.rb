class AddCompletedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :completed_at, :datetime
  end
end
