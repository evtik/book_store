class AddOderIdToCreditCards < ActiveRecord::Migration[5.0]
  def change
    add_column :credit_cards, :order_id, :integer
    add_index :credit_cards, :order_id
  end
end
