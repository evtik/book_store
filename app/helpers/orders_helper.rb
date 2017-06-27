module OrdersHelper
  FILTERS = %w(in_progress in_queue in_delivery delivered canceled).freeze

  def current_orders_filter
    filter_params[:filter] || 'all'
  end

  def filter_params
    params.permit(:filter, :user_id)
  end
end
