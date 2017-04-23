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
    if @order.addresses_valid?
      redirect_to action: 'delivery'
    else
      redirect_to action: 'address'
    end
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
    session[:order] = @order
    if @order.shipment_id
      redirect_to action: 'payment'
    else
      redirect_to action: 'delivery'
    end
  end

  def payment
    order_from_session
    redirect_to action: 'delivery' if @order.shipment_id.nil?
    @card = if session[:card]
              CreditCardForm.from_params(session[:card])
            else
              CreditCardForm.new
            end
    @card.valid?
  end

  def submit_payment
    @card = CreditCardForm.from_params(params)
    session[:card] = @card
    if @card.valid?
      redirect_to action: 'confirm'
    else
      redirect_to action: 'payment'
    end
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
