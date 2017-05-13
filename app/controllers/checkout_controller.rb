class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def address
    # redirect to /cart if the cart is empty
    order_from_session
    initialize_order if @order.nil?
    session[:order] = @order
    @countries = Country.all.map { |c| [c.name, c.country_code] }
  end

  def submit_address
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
    shipment_price = @shipments.find(@order.shipment_id).price
    session[:shipment] = shipment_price
    session[:order_total] = session[:order_subtotal].to_f + shipment_price
    session[:order] = @order
  end

  def submit_delivery
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
    card = session[:order]['card']
    if card
      @card = CreditCardForm.from_params(card)
      @card.valid?
    else
      @card = CreditCardForm.new
    end
  end

  def submit_payment
    @card = CreditCardForm.from_params(params)
    @card.number.delete!('-')
    session[:order]['card'] = @card
    redirect_to action: @card.valid? ? 'confirm' : 'payment'
  end

  def confirm
    card = session[:order]['card']
    redirect_to action: 'payment' unless card
    order_from_session
    @order_items = order_items_from_cart
    @card = CreditCardForm.from_params(card)
    @shipment = Shipment.find(@order.shipment_id)
  end

  def submit_confirm
    redirect_to action: 'complete'
  end

  def complete
  end

  private

  def order_from_session
    return unless session[:order]
    @order = OrderForm.from_params(session[:order])
    @order.valid?
  end

  def initialize_order
    @order = OrderForm.new
    @order.billing = fetch_or_create_address('billing')
    @order.shipping = fetch_or_create_address('shipping')
  end

  def fetch_or_create_address(type)
    address = UserAddress.new(current_user.id, type).to_a.first
    address ? AddressForm.from_model(address) : AddressForm.new
  end
end
