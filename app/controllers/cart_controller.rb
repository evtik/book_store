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
    session[:cart][book_id] += quantity
    redirect_to :back
  end

  def update
    params[:quantities].each do |book_id, quantity|
      session[:cart][book_id] = quantity.to_i
    end
    redirect_to :cart
  end

  def remove
    session[:cart].except!(params[:id])
    redirect_to :cart
  end

  private

  def set_cart
    session[:cart] ||= Cart.new
  end
end
