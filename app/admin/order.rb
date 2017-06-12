ActiveAdmin.register Order do
  config.batch_actions = true
  config.filters = false

  # filter :state, as: :select

  scope :all, default: true
  scope :in_progress
  scope :in_queue
  scope :in_delivery
  scope :delivered
  scope :canceled

  index do
    selectable_column
    column('Order') { |order| order.decorate.number }
    state_column :state
    column 'Date', :created_at
    column 'Customer', :user, sortable: :user_id
    column('Subtotal') { |order| number_to_currency order.subtotal }
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
    before_action :set_order, only: [:queue, :deliver, :complete, :cancel]

    def queue
      @order.queue!
      redirect_to request.referrer
    end

    def deliver
      @order.deliver!
      redirect_to request.referrer
    end

    def complete
      @order.complete!
      redirect_to request.referrer
    end

    def cancel
      @order.cancel!
      redirect_to request.referrer
    end

    private

    def set_order
      @order = Order.find(params[:order_id])
    end
  end

  form do |f|
    f.input :aasm_read_state, label: 'Change state', as: :select,
      collection: f.object.aasm.events(permitted: true).map(&:name)
    f.actions
  end

  permit_params :aasm_read_state
end
