class OrdersController < ApplicationController
  # load_and_authorize_resource only: [:index, :show]
  load_and_authorize_resource only: :index

  def index
    filter = permitted[:filter]
    @orders = @orders.where(state: filter) if filter
    @orders = OrderDecorator.decorate_collection(@orders)
  end

  def show
    initialize_order
    initialize_addresses
    @order_items = @order.order_items
    @order.credit_card = @order.credit_card.decorate
  end

  private

  def permitted
    params.permit(:filter, :id, :order_id)
  end

  def initialize_order
    @order = Order.includes(:addresses, :credit_card, :shipment,
                            :coupon, order_items: [:book])
                  .where(id: permitted[:order_id])
                  .first
                  .decorate
    authorize! :show, @order
  end

  def initialize_addresses
    @billing = @order.addresses.where(address_type: 'billing').first
    @shipping = @order.addresses.where(address_type: 'shipping').first
    @shipping ||= @billing
  end
end
