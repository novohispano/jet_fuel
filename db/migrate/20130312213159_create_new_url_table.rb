class CreateNewUrlTable < ActiveRecord::Migration
  def change
    drop_table :urls

    create_table :urls do |t|
      t.string :original
      t.string :shortened
      t.string :user_id
      t.timestamps
    end
  end
end