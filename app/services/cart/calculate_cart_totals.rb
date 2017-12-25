module Cart
  class CalculateCartTotals < BaseService
    def call(session)
      cart = session[:cart]
      cut = session[:discount]
      books = Book.find cart.keys
      items_total = cart.values.each_with_index.sum do |quantity, index|
        quantity * books[index].price
      end
      discount = cut ? (items_total * cut / 100) : 0.0
      [items_total, items_total - discount, discount]
    end
  end
end
