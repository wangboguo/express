class CreateStoreOrderInfos < ActiveRecord::Migration
  def change
    create_table :store_order_infos do |t|
      t.string :shipping_name
      t.string :shipping_address
      t.integer :order_id

      t.timestamps null: false
    end
  end
end
