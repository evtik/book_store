class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def address
    # redirect to /cart if the cart is empty
    order_from_session
    initialize_order if @order.nil?
    session[:order] = @order
  end

  def submit_address
    # byebug
    # order_from_params
    @order = OrderForm.from_params(session[:order]
      .merge(params.require(:order).permit!.to_h))
    session[:order] = @order
    redirect_to action: @order.addresses_valid? ? 'delivery' : 'address'
  end

  def delivery
    order_from_session
    redirect_to action: 'address' if @order.nil?
    @shipments = Shipment.all
    @order.shipment_id ||= 1
    session[:order] = @order
  end

  def submit_delivery
    # order_from_params
    @order = OrderForm.from_params(session[:order])
    @order.shipment_id = params[:shipment_id]
    session[:shipment] = params[:shipment_price]
    session[:order_total] = session[:order_subtotal].to_f +
      session[:shipment].to_f
    session[:order] = @order
    redirect_to action: @order.shipment_id ? 'payment' : 'delivery'
  end

  def payment
    order_from_session
    redirect_to action: 'delivery' if @order.shipment_id.nil?
    if session[:card]
      @card = CreditCardForm.from_params(session[:card])
      @card.valid?
    else
      @card = CreditCardForm.new
    end
  end

  def submit_payment
    @card = CreditCardForm.from_params(params)
    @card.number.delete!('-')
    session[:card] = @card
    redirect_to action: @card.valid? ? 'confirm' : 'payment'
  end

  def confirm
    redirect_to action: 'payment' unless session[:card]
    order_from_session
    @order_items = order_items_from_cart
    @card = CreditCardForm.from_params(session[:card])
  end

  private

  def order_from_session
    return unless session[:order]
    @order = OrderForm.from_params(session[:order])
    @order.valid?
  end

  def order_from_params
    # @order = OrderForm.from_params(params)
    # depends on the step, cannot use the same logic
    @order = OrderForm.from_params(session[:order]
      .merge!(params.permit!.to_h.slice(:order)[:order]))
  end

  def initialize_order
    @order = OrderForm.new
    @order.billing = fetch_or_create_address('billing')
    @order.shipping = fetch_or_create_address('shipping')
    # session[:order] = @order
  end

  def fetch_or_create_address(type)
    address = UserAddress.new(current_user.id, type).to_a.first
    address ? AddressForm.from_model(address) : AddressForm.new
  end
end
