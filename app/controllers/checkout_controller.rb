class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action -> { @order = Checkout::BuildOrder.call(session[:order]) },
                only: [:address, :delivery, :payment, :confirm],
                if: -> { session[:order] }

  def address
    return redirect_to cart_path if session[:cart].nil? || session[:cart].empty?
    initialize_order unless @order
    @countries = COUNTRIES
  end

  def submit_address
    order_from_params(params.require(:order))
    redirect_to action: @order.addresses_valid? ? 'delivery' : 'address'
  end

  def delivery
    return redirect_to action: 'address' unless @order
    @shipments = Shipment.all
    initialize_shipment unless @order.shipment
  end

  def submit_delivery
    order_from_params(params)
    redirect_to action: @order&.shipment ? 'payment' : 'delivery'
  end

  def payment
    return redirect_to action: 'delivery' unless @order&.shipment
    @order.card ||= CreditCardForm.new
  end

  def submit_payment
    order_from_params(params.require(:order))
    redirect_to action: @order.card.valid? ? 'confirm' : 'payment'
  end

  def confirm
    return redirect_to action: 'payment' unless @order&.card
    @shipping = @order.use_billing ? @order.billing : @order.shipping
    @billing = @order.billing
    @order_items = Common::CreateOrderItemsFromCart.call(session[:cart])
    @order.credit_card = CreditCard.new(@order.card.to_h).decorate
  end

  def submit_confirm
    order = session[:order]
    @order = Order.new(
      user_id: current_user.id, coupon_id: session[:coupon_id],
      shipment_id: order['shipment_id'], subtotal: order['subtotal']
    )
    populate_addresses(order)
    @order.credit_card = CreditCard.new(order['card'])
    @order.order_items << Common::CreateOrderItemsFromCart.call(session[:cart])
    submit_order
  end

  def complete
    flash.keep
    return redirect_to cart_path unless flash[:order_confirmed]
    @order = UserLastOrder.new(current_user.id).first.decorate
    @order_items = @order.order_items
  end

  private

  def order_from_params(order_params)
    @order = OrderForm.from_params(session[:order]
      .merge(order_params.permit!.to_h))
    @order.card.number.delete!('-') if @order.card.present?
    session[:order] = @order
  end

  def initialize_order
    @order = OrderForm.new
    @order.billing = Common::GetOrCreateAddress.call(current_user.id, 'billing')
    @order.shipping = Common::GetOrCreateAddress.call(current_user.id,
                                                      'shipping')
    @order.items_total = session[:items_total]
    @order.subtotal = session[:order_subtotal]
    session[:order] = @order
  end

  def initialize_shipment
    @order.shipment_id = @shipments.first.id
    @order.shipment = ShipmentForm.from_model(@shipments.first)
  end

  def populate_addresses(order)
    @order.addresses << Address.new(order['billing'].except!('id'))
    return if order['use_billing']
    @order.addresses << Address.new(order['shipping'].except!('id'))
  end

  def submit_order
    if @order.save
      begin
        %i[cart order discount coupon_id].each { |key| session.delete(key) }
        flash[:order_confirmed] = true
        NotifierMailer.order_email(@order).deliver
      ensure
        redirect_to action: 'complete'
      end
    else
      flash[:alert] = 'Something went wrong...'
      redirect_to action: 'confirm'
    end
  end
end
