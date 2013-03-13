class AddUsersToUrlTable < ActiveRecord::Migration
  def change
    change_table :urls do |t|
      t.string :user_id,
      t.timestamps
    end
  end
end