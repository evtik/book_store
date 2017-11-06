class OrdersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource only: :index

  def index
    filter = order_params[:filter]
    @orders = @orders.order('id desc')
    @orders = @orders.where(state: filter) if filter
    @orders = OrderDecorator.decorate_collection(@orders)
  end

  def show
    @order = Orders::GetOrderById.call(order_params[:order_id])
    authorize! :show, @order
    @billing = @order.billing_address
    @shipping = @order.shipping_address
    @order_items = @order.order_items
    @order.credit_card = @order.credit_card.decorate
  end

  private

  def order_params
    # do i need id here?
    params.permit(:id, :order_id, :filter)
  end
end
