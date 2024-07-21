class CreateOrderDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :order_details do |t|
      t.references :order_header_id, null: false, foreign_key: true
      t.references :product_id, null: false, foreign_key: true
      t.integer :order_amount
      t.integer :received_amount
      t.integer :order_unit
      t.date :wanted_delay
      t.date :confirmed_delay
      t.float :unit_price
      t.string :status
      t.string :created_by

      t.timestamps
    end
  end
end
