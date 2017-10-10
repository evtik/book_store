class CreateOrderItemsFromCart < Rectify::Command
  def initialize(cart)
    @cart = cart
  end

  def call
    @cart.map do |book_id, quantity|
      OrderItem.new do |order_item|
        order_item.book_id = book_id
        order_item.quantity = quantity.to_i
      end
    end
  end
end
