class AddCouponIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :coupon_id, :integer
    add_index :orders, :coupon_id
  end
end
