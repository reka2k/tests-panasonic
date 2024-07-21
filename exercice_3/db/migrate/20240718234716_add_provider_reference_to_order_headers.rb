class AddProviderReferenceToOrderHeaders < ActiveRecord::Migration[7.1]
  def change
    add_reference :order_headers, :provider, null: true, foreign_key: true
  end
end
