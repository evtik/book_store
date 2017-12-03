ActiveAdmin.register Order do
  actions :index

  config.filters = false

  scope I18n.t('.active_admin.resource.index.all'), :all, default: true
  scope I18n.t('.active_admin.resource.index.order.in_progress') do |scope|
    scope.where(state: %w(in_progress in_queue in_delivery))
  end
  scope I18n.t('.active_admin.resource.index.order.delivered'), :delivered
  scope I18n.t('.active_admin.resource.index.order.canceled'), :canceled

  index do
    column(t('.order.order')) { |order| order.decorate.number }
    state_column t('.order.state'), :state
    column t('.order.date'), :created_at
    column t('.order.customer'), :user, sortable: :user_id
    column(t('.order.total')) do |order|
      number_to_currency order.subtotal + order.shipment.price
    end
    column(t('.actions')) do |order|
      actions = %w(queue deliver complete cancel).map do |action|
        next unless order.send("may_#{action}?")
        link_to(
          t(".order.#{action}"), send("order_#{action}_path", order.id),
          method: :put, class: "button #{action}_button"
        )
      end
      raw actions.join(' ')
    end
  end

  controller do
    %i(queue deliver complete cancel).each do |action|
      define_method action do
        Order.find(params[:order_id]).send(action.to_s << '!')
        redirect_to request.referrer
      end
    end
  end
end
