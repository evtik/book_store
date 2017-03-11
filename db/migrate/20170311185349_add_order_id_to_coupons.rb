class AddOrderIdToCoupons < ActiveRecord::Migration[5.0]
  def change
    add_reference :coupons, :order, foreign_key: true
  end
end
