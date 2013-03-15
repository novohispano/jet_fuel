class ChangingIdsToIntegers < ActiveRecord::Migration
  def change
    change_column :requests, :user_url_id, :integer
    change_column :requests, :url_id, :integer    
    change_column :user_urls, :user_id, :integer    
    change_column :urls, :user_id, :integer
  end
end