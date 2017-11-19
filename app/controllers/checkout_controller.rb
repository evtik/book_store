class CheckoutController < ApplicationController
  include Rectify::ControllerHelpers

  before_action :authenticate_user!
  before_action -> { @order = Checkout::BuildOrder.call(session[:order]) },
                only: [:address, :delivery, :payment, :confirm],
                if: -> { session[:order] }
  before_action -> { present CheckoutPresenter.new },
                only: [:address, :delivery, :payment, :confirm, :complete]

  def address
    return redirect_to cart_path if session[:cart].nil? || session[:cart].empty?
    @order ||= Checkout::InitializeOrder.call(session)
    @countries = COUNTRIES
  end

  def submit_address
    @order = Checkout::UpdateOrder.call(session,
                                        params.require(:order).permit!.to_h)
    redirect_to action: @order.addresses_valid? ? 'delivery' : 'address'
  end

  def delivery
    return redirect_to action: 'address' unless @order
    @shipments = Shipment.all
    return if @order.shipment
    @order.shipment_id = @shipments.first.id
    @order.shipment = ShipmentForm.from_model(@shipments.first)
  end

  def submit_delivery
    @order = Checkout::UpdateOrder.call(session, params.permit!.to_h)
    redirect_to action: @order&.shipment ? 'payment' : 'delivery'
  end

  def payment
    return redirect_to action: 'delivery' unless @order&.shipment
    @order.card ||= CreditCardForm.new
  end

  def submit_payment
    @order = Checkout::UpdateOrder.call(session,
                                        params.require(:order).permit!.to_h)
    redirect_to action: @order.card.valid? ? 'confirm' : 'payment'
  end

  def confirm
    return redirect_to action: 'payment' unless @order&.card
    @shipping = @order.use_billing ? @order.billing : @order.shipping
    @billing = @order.billing
    @order_items = Common::BuildOrderItemsFromCart.call(session[:cart])
    @order.credit_card = CreditCard.new(@order.card.to_h).decorate
  end

  def submit_confirm
    Checkout::SubmitOrder.call(session) do
      on(:ok) do
        flash[:order_confirmed] = true
        redirect_to action: 'complete'
      end

      on(:error) do |error_message|
        flash[:error] = error_message
        redirect_to action: 'confirm'
      end
    end
  end

  def complete
    flash.keep
    return redirect_to cart_path unless flash[:order_confirmed]
    @order = UserLastOrder.new(current_user.id).first.decorate
    @order_items = @order.order_items
  end
end
