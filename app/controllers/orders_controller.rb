class OrdersController < ApplicationController
  load_and_authorize_resource only: :index

  def index
    filter = order_params[:filter]
    @orders = @orders.order('id desc')
    @orders = @orders.where(state: filter).order('id desc') if filter
    @orders = OrderDecorator.decorate_collection(@orders)
  end

  def show
    authenticate_user!
    initialize_order
    initialize_addresses
    @order_items = @order.order_items
    @order.credit_card = @order.credit_card.decorate
  end

  private

  def order_params
    params.permit(:id, :order_id, :filter)
  end

  def initialize_order
    @order = Order.includes(:addresses, :credit_card, :shipment,
                            :coupon, order_items: [:book])
                  .where(id: order_params[:order_id])
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
