class AddSubtotalToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :subtotal, :decimal, precision: 6, scale: 2
  end
end
