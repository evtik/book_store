class OrdersController < ApplicationController
  load_and_authorize_resource only: [:index, :show]

  def index
    filter = permitted[:filter]
    @orders = @orders.where(state: filter) if filter
    @orders = OrderDecorator.decorate_collection(@orders)
  end

  def show
    # @order = Order.find(params[:id])
    # authorize! :show, @order
  end

  private

  def permitted
    params.permit(:filter, :user_id)
  end
end
