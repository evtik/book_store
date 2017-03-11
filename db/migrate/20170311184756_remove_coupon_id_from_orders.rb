class RemoveCouponIdFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_reference :orders, :coupon, foreign_key: true
  end
end
