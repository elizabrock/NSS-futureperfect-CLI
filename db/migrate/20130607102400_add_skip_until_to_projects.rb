class AddSkipUntilToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :skip_until, :datetime
  end
end
