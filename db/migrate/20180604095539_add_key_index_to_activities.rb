class AddKeyIndexToActivities < ActiveRecord::Migration
  def change
    add_index :activities, :key
  end
end
