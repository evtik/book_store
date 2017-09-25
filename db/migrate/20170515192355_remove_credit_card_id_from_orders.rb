class RemoveCreditCardIdFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :credit_card_id, :integer
  end
end
