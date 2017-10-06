class CartController < ApplicationController
  before_action { session[:cart] ||= Hash.new(0) }

  def index
    @order_items = Cart::CreateOrderItemsFromCart.call(session[:cart])
    @items_total, @discount, @order_subtotal = Cart::CalculateCartTotals.call(
      session[:cart], session[:discount]
    )
    session[:items_total] = @items_total
    session[:order_subtotal] = @order_subtotal
  end

  def add
    book_id = params[:id]
    quantity = params[:quantity].present? ? params[:quantity].to_i : 1
    session[:cart][book_id] ||= 0
    session[:cart][book_id] += quantity
    flash.keep
    redirect_back(fallback_location: root_path)
  end

  def update
    params[:quantities].each do |book_id, quantity|
      session[:cart][book_id] = quantity.present? ? quantity.to_i : 1
    end

    handle_coupon if params[:coupon]

    redirect_to cart_index_path
  end

  def remove
    session[:cart].except!(params[:id])
    redirect_to cart_index_path
  end

  private

  def handle_coupon
    HandleCoupon.call(params[:coupon]) do
      on(:invalid) do |error_message|
        flash[:alert] = error_message
        flash.keep
      end

      on(:valid) do |coupon|
        session[:coupon_id] = coupon.id
        session[:discount] = coupon.discount
      end
    end
  end
end
