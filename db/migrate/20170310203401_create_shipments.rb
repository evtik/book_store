class CreateShipments < ActiveRecord::Migration[5.0]
  def change
    create_table :shipments do |t|
      t.string :method
      t.integer :days_min
      t.integer :days_max
      t.decimal :price, precision: 5, scale: 2

      t.timestamps
    end
  end
end
