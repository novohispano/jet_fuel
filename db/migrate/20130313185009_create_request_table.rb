class CreateRequestTable < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :value
      t.string :url_id
      t.timestamps
    end
  end
end
