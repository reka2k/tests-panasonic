class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.text :description
      t.integer :stocking_unit
      t.string :familiy
      t.float :net_unit_weight
      t.float :brut_unit_weight
      t.integer :total_available_stock
      t.integer :total_unavailable_stock
      t.integer :on_hold_sale_quantity
      t.integer :on_hold_delivery_quantity
      t.string :default_location
      t.string :created_by

      t.timestamps
    end
  end
end
