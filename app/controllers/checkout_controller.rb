class CheckoutController < ApplicationController
  include Wicked::Wizard
  before_action :authenticate_user!
  steps :address, :delivery, :payment, :confirm, :complete

  def show
    case step
    when :address
      @current_order = Order.new
      if @current_order.addresses.length.zero?
        current_user.addresses.each do |address|
          @current_order.addresses << Address.new(address.attributes.except('id', 'user_id'))
        end
      end
      Rails.cache.write("order_#{current_user.id}", @current_order,
                        expires_in: 1.hour)
    end
    render_wizard
  end

  def update
    @current_order = Rails.cache.read("order_#{current_user.id}")
    case step
    when :address
      # @user = current_user
      billing_address = Address.new(billing_address_params)
      if billing_address.valid?
        redirect_to next_wizard_path
      else
        @current_order.addresses.first.update_attributes(billing_address_params)
        render_wizard
      end
    end
  end

  private

  def billing_address_params
    params.require(:billing).permit(:firstname, :zip)
  end
end
