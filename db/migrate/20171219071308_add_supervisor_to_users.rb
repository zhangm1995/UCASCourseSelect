class AddSupervisorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :supervisor, :text
  end
end
