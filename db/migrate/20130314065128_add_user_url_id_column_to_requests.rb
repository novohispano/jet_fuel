class AddUserUrlIdColumnToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :user_url_id, :string
  end
end