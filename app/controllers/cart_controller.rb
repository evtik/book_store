class CartController < ApplicationController
  before_action :set_cart

  def index
    @order_items = order_items_from_cart
    calculate_totals
  end

  def add
    book_id = params[:id]
    quantity = params[:quantity].present? ? params[:quantity].to_i : 1
    session[:cart][book_id] ||= 0
    session[:cart][book_id] += quantity
    flash.keep
    redirect_to :back
  end

  def update
    params[:quantities].each do |book_id, quantity|
      session[:cart][book_id] = quantity.present? ? quantity.to_i : 1
    end
    handle_coupon
    calculate_totals
    redirect_to cart_index_path
  end

  def remove
    session[:cart].except!(params[:id])
    redirect_to cart_index_path
  end

  private

  def set_cart
    session[:cart] ||= Cart.new
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
    @coupon_states = [@coupon.nil?, @coupon&.order.present?]
    @coupon_states << (@coupon_states.any? ? nil : @coupon.expires < Date.today)
    @coupon_states.any? ? coupon_message : coupon_discount
  end

  def coupon_message
    flash[:error] = coupon_messages[@coupon_states]
    flash.keep
  end

  def coupon_discount
    session[:coupon_id] = @coupon.id
    session[:discount] = @coupon.discount
  end

  def coupon_messages
    {
      [false, true, nil] => I18n.t('coupon.taken'),
      [false, false, true] => I18n.t('coupon.expired'),
      [true, false, nil] => I18n.t('coupon.not_exist')
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
