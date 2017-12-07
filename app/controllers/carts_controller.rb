class CartsController < ApplicationController
  before_action { session[:cart] ||= Hash.new(0) }

  def show
    @order_items = Common::BuildOrderItemsFromCart.call(session[:cart])
    @items_total, @discount, @order_subtotal = Cart::CalculateCartTotals.call(
      session[:cart], session[:discount]
    )
    session[:items_total] = @items_total
    session[:order_subtotal] = @order_subtotal
  end

  def update
    params[:quantities].each do |book_id, quantity|
      session[:cart][book_id] = quantity.present? ? quantity.to_i : 1
    end

    handle_coupon if params[:coupon].present?

    redirect_to cart_path
  end

  private

  def handle_coupon
    Cart::HandleCoupon.call(params[:coupon]) do
      on(:error) do |error_message|
        flash[:alert] = error_message
        flash.keep
      end

      on(:ok) do |coupon|
        session[:coupon_id] = coupon.id
        session[:discount] = coupon.discount
      end
    end
  end
end
