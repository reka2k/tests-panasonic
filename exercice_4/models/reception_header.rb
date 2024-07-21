class CreateReceptionHeaders < ActiveRecord::Migration[5.2]
  def change
    create_table :reception_headers do |t|
      t.references :provider
      t.string :provider_shipping_number
      t.datetime :reception_date
      t.string :status

      t.timestamps
    end
  end
end
