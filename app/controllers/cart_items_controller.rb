class CartItemsController < ApplicationController
  before_action { session[:cart] ||= Hash.new(0) }

  def create
    book_id = params[:id]
    quantity = params[:quantity].present? ? params[:quantity].to_i : 1
    session[:cart][book_id] ||= 0
    session[:cart][book_id] += quantity
    flash.keep
    redirect_back(fallback_location: root_path)
  end

  def destroy
    session[:cart].except!(params[:id])
    redirect_to(cart_path)
  end
end
