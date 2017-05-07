class CartController < ApplicationController
  before_action :set_cart

  def index
    @order_items = session[:cart].map do |book_id, quantity|
      OrderItem.new do |order_item|
        order_item.book_id = book_id
        order_item.quantity = quantity.to_i
      end
    end
    calculate_totals
  end

  def add
    book_id = params[:id]
    quantity = params[:quantity].to_i || 1
    # don't know why it is nil by default
    # though session[:cart] is created like Hash.new(0)
    session[:cart][book_id] ||= 0
    session[:cart][book_id] += quantity
    redirect_to :back
  end

  def update
    params[:quantities].each do |book_id, quantity|
      session[:cart][book_id] = quantity.to_i
    end
    session[:coupon] = params[:coupon]
    redirect_to :cart
  end

  def remove
    session[:cart].except!(params[:id])
    redirect_to :cart
  end

  private

  def set_cart
    session[:cart] ||= Cart.new
    # session[:cart] ||= Hash.new(0)
  end

  def items_total
    books = Book.find session[:cart].keys
    session[:cart].values.each_with_index.sum do |quantity, index|
      quantity * books[index].price
    end
  end

  def calculate_discount
    @coupon = Coupon.where(code: session[:coupon]).first if session[:coupon]
    outcomes = {
      [false, false, false] => [nil, @coupon&.discount],
      [false, true, nil] => ['This coupon is already used!', 0.0],
      [false, false, true] => ['This coupon has expired!', 0.0],
      [true, nil, nil] => ['This coupon does not exist!', 0.0]
    }
    result = outcomes[[@coupon.nil?, @coupon&.order_id?, coupon_expired?]]
    flash[:error] = result.first if result.first
    result.last
  end

  def coupon_expired?
    (@coupon.nil? || @coupon.order_id?) ? nil : @coupon.expires < Date.today
  end

  def calculate_totals
    @items_total = items_total
    @discount = @items_total * calculate_discount / 100
    @order_subtotal = @items_total - @discount
  end
end
