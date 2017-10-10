class CalculateCartTotals < Rectify::Command
  def initialize(*args)
    @cart = args[0]
    @cut = args[1]
  end

  def call
    books = Book.find @cart.keys
    items_total = @cart.values.each_with_index.sum do |quantity, index|
      quantity * books[index].price
    end
    discount = @cut ? (items_total * @cut / 100) : 0.0
    [items_total, discount, items_total - discount]
  end
end
