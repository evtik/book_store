class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def address
    return redirect_to '/cart' if session[:cart].nil? || session[:cart].empty?
    order_from_session
    initialize_order if @order.nil?
    session[:order] = @order
    @countries = COUNTRIES
  end

  def submit_address
    @order = OrderForm.from_params(session[:order]
      .merge(params.require(:order).permit!.to_h))
    session[:order] = @order
    redirect_to action: @order.addresses_valid? ? 'delivery' : 'address'
  end

  def delivery
    order_from_session
    return redirect_to action: 'address' if @order.nil?
    @shipments = Shipment.all
    @order.shipment_id ||= 1
    @subtotal = session[:order_subtotal].to_f
    @shipment_price = @shipments.find(@order.shipment_id).price
    @total = @subtotal + @shipment_price
  end

  def submit_delivery
    @order = OrderForm.from_params(session[:order])
    @order.shipment_id = params[:shipment_id]
    session[:shipment] = params[:shipment_price]
    session[:order_total] = session[:order_subtotal].to_f +
                            session[:shipment].to_f
    session[:order] = @order
    redirect_to action: 'payment'
  end

  def payment
    order_from_session
    return redirect_to action: 'delivery' if @order&.shipment_id.nil?
    card = session[:order]['card']
    if card
      @card = CreditCardForm.from_params(card)
      @card.valid?
    else
      @card = CreditCardForm.new
    end
    totals_from_session
  end

  def submit_payment
    @card = CreditCardForm.from_params(params)
    @card.number.delete!('-')
    session[:order]['card'] = @card
    redirect_to action: @card.valid? ? 'confirm' : 'payment'
  end

  def confirm
    card = session[:order]['card'] if session[:order]
    return redirect_to action: 'payment' unless card
    order_from_session
    @order_items = order_items_from_cart
    @card = CreditCardForm.from_params(card)
    @shipment = Shipment.find(@order.shipment_id)
    totals_from_session
  end

  def submit_confirm
    order = session[:order]
    @order = Order.new(user_id: current_user.id, state: 'in_progress')
    populate_addresses(order)
    @order.shipment_id = order['shipment_id']
    @order.credit_card = CreditCard.new(order['card'])
    @order.order_items << order_items_from_cart
    @order.coupon_id = session[:coupon_id]
    @order.subtotal = session[:order_subtotal]
    @order.total = session[:order_total]
    submit_order
  end

  def complete
    flash.keep
    return redirect_to '/cart' unless flash[:order_confirmed]
    @order = UserLastOrder.new(current_user.id).to_a.first.decorate
    @order_items = @order.order_items
    @subtotal = @order.subtotal
    @shipment_price = @order.shipment.price
    @total = @order.total
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

  def totals_from_session
    @subtotal = session[:order_subtotal]
    @shipment_price = session[:shipment]
    @total = session[:order_total]
  end

  def populate_addresses(order)
    @order.addresses << Address.new(order['billing'].except!('id'))
    return unless order['use_billing_address'].zero?
    @order.addresses << Address.new(order['shipping'].except!('id'))
  end

  def submit_order
    if @order.save
      clear_session
      flash[:order_confirmed] = true
      redirect_to action: 'complete'
    else
      flash[:error] = 'Something went wrong...'
      redirect_to action: 'confirm'
    end
  end

  def clear_session
    %i(cart order discount coupon_id items_total order_subtotal shipment
       order_total).each { |key| session.delete(key) }
  end
end
