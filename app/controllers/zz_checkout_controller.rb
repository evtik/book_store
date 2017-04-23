class CheckoutController < ApplicationController
  include Wicked::Wizard
  before_action :authenticate_user!
  steps :address, :delivery, :payment, :confirm, :complete

  def show
    if session[:current_order]
      @current_order = OrderForm.from_params(session[:current_order])
    else
      @current_order = OrderForm.new
      @current_order.billing =
        AddressForm.from_model(UserAddress.new(current_user.id, 'billing').first)
      shipping_address = UserAddress.new(current_user.id, 'shipping').first
      if shipping_address
        @current_order.shipping =
          AddressForm.from_model(shipping_address)
      else
        @current_order.shipping = AddressForm.new
      end
      session[:current_order] = @current_order
    end
    case step
    when :address
    end
    render_wizard
  end

  def update
    @current_order = OrderForm.from_params(params)
    condition = @current_order.billing.valid? &&
                (@current_order.use_billing_address == 1 ||
                (@current_order.use_billing_address.zero? &&
                @current_order.shipping.valid?))
    session[:current_order] = @current_order
    if condition
      redirect_to next_wizard_path
    else
      render_wizard
    end
  end
end
