class CreateReceptionDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :reception_details do |t|
      t.references :reception_header, foreign_key: true
      t.references :order_header, foreign_key: true
      t.references :order_detail, foreign_key: true
      t.integer :received_quantity
      t.string :created_by

      t.timestamps
    end
  end
end
