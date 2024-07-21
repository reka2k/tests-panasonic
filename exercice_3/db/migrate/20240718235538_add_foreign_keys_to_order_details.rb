class AddForeignKeysToOrderDetails < ActiveRecord::Migration[7.1]
  def change
    add_reference :order_details, :order_header, null: false, foreign_key: true
    add_reference :order_details, :product, null: false, foreign_key: true
  end
end
