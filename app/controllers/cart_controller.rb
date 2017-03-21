class CartController < ApplicationController
  before_action :set_cart

  def index
    @order_items = session[:cart].map do |book_id, quantity|
      OrderItem.new do |order_item|
        order_item.book_id = book_id
        order_item.quantity = quantity.to_i
      end
    end
  end

  def add
    book_id = params[:id]
    quantity = params[:quantity].to_i || 1
    # don't know why it is nil by default
    # though session[:cart] is created like Hash.new(0)
    session[:cart][book_id] ||= 0
    session[:cart][book_id] += quantity
    Rails.cache.write('my_key', 'foo', expires_in: 1.hour)
    redirect_to :back
  end

  def update
    params[:quantities].each do |book_id, quantity|
      session[:cart][book_id] = quantity.to_i
    end
    logger.info('bar')
    logger.info(Rails.cache.read('my_key'))
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
end
