class CreateUserUrls < ActiveRecord::Migration
  def change
    create_table :user_urls do |t|
      t.string :original
      t.string :shortened
      t.string :user_id
      t.timestamps
    end
  end
end
