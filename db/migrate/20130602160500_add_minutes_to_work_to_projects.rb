class AddMinutesToWorkToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :minutes_to_work, :integer, default: 30
  end
end
