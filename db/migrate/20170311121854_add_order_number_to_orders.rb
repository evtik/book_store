class AddOrderNumberToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :order_number, :string
  end
end
