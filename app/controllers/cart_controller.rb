class CartController < ApplicationController
  before_action :set_cart

  def index
    books = Book.find(session[:cart].keys)
    @order_items = session[:cart].map do |k, v|
      OrderItem.new do |oi|
        # oi.book = books.select { |book| book.id == k }.first
        oi.book_id = k.to_i
        oi.quantity = v.to_i
      end
    end
  end

  def add_item
    session[:cart][params[:id]] = params[:quantity]
    redirect_to :back
  end

  def update_quantity
    # logger.info params[:quantities]
    logger.info params[:quan_3]
  end

  def remove_item
    session[:cart].except!(params[:id])
    redirect_to :cart
  end

  private

  def set_cart
    session[:cart] ||= Cart.new
  end
end
