class RemoveFkConstrainsFromOrderHeaders < ActiveRecord::Migration[7.1]
  def change
    remove_column :order_headers, :provider_id
  end
end
