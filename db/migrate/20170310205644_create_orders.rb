class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.references :credit_card, foreign_key: true
      t.references :coupon, foreign_key: true
      t.references :shipment, foreign_key: true
      t.string :state
      t.decimal :total, precision: 6, scale: 2

      t.timestamps
    end
  end
end
