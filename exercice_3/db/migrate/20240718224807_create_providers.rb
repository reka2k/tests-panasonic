class CreateProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :providers do |t|
      t.text :description
      t.string :address1
      t.string :adresse2
      t.integer :zipcode
      t.string :contact_name
      t.string :contact_mail
      t.string :iban
      t.string :created_by

      t.timestamps
    end
  end
end
