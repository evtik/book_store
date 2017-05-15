class CartController < ApplicationController
  before_action :set_cart

  def index
    @order_items = order_items_from_cart
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
    handle_coupon
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

  def handle_coupon
    return if params[:coupon].blank?
    @coupon = Coupon.where(code: params[:coupon]).first
    @coupon_conditions = [@coupon.nil?, @coupon&.order_id?, coupon_expired?]
    @coupon_conditions.any? ? coupon_message : coupon_discount
  end

  def coupon_expired?
    @coupon.nil? || @coupon.order_id? ? nil : @coupon.expires < Date.today
  end

  def coupon_message
    flash[:error] = coupon_messages[@coupon_conditions]
    flash.keep
  end

  def coupon_discount
    session[:coupon_id] = @coupon.id
    session[:discount] = @coupon.discount
  end

  def coupon_messages
    {
      [false, true, nil] => 'This coupon is already used!',
      [false, false, true] => 'This coupon has expired!',
      [true, nil, nil] => 'This coupon does not exist!'
    }
  end

  def calculate_totals
    @items_total = items_total
    cut = session[:discount]
    @discount = cut ? (@items_total * cut / 100) : 0.0
    @order_subtotal = @items_total - @discount
    session[:items_total] = @items_total
    session[:order_subtotal] = @order_subtotal
  end
end
