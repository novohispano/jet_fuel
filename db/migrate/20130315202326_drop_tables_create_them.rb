class DropTablesCreateThem < ActiveRecord::Migration
  def change
    drop_table :urls
    drop_table :requests
    drop_table :user_urls

    create_table :urls do |t|
      t.string  :original
      t.string  :shortened
      t.integer :user_id
      t.integer :request_id
      t.timestamps
    end

    create_table :requests do |t|
      t.string  :value
      t.integer :url_id
      t.integer :user_url_id
    end

    create_table :user_urls do |t|
      t.string  :original
      t.string  :shortened
      t.integer :user_id
      t.integer :request_id
      t.timestamps
    end
  end
end