class CreateOrderHeaders < ActiveRecord::Migration[7.1]
  def change
    create_table :order_headers do |t|
      t.references :provider_id, null: false, foreign_key: true
      t.string :status
      t.string :created_by

      t.timestamps
    end
  end
end
