ActiveAdmin.register Order do
  config.batch_actions = true
  config.filters = false

  scope :all, default: true
  scope('In progress') do |scope|
    scope.where(state: %w(in_progress in_queue in_delivery))
  end
  scope :delivered
  scope :canceled

  index do
    selectable_column
    column('Order') { |order| order.decorate.number }
    state_column :state
    column 'Date', :created_at
    column 'Customer', :user, sortable: :user_id
    column('Total') do |order|
      number_to_currency order.subtotal + order.shipment.price
    end
    column 'Actions' do |order|
      actions = %w(queue deliver complete cancel).map do |action|
        next unless order.send("may_#{action}?")
        link_to(
          action.humanize, send("order_#{action}_path", order.id),
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
