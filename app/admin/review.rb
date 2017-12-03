ActiveAdmin.register Review do
  actions :index

  config.filters = false

  scope I18n.t('.active_admin.resource.index.all'), :all, default: true
  scope I18n.t('.active_admin.resource.index.review.unprocessed'), :unprocessed
  scope I18n.t('.active_admin.resource.index.review.approved'), :approved
  scope I18n.t('.active_admin.resource.index.review.rejected'), :rejected

  index do
    column :id
    column(t('.review.book')) { |review| review.book.title }
    column t('.review.date'), :created_at
    column(t('.review.user')) { |review| review.user.email }
    state_column t('.review.state'), :state
    column(t('.actions')) do |review|
      actions = %w(approve reject).map do |action|
        next unless review.send("may_#{action}?")
        link_to(
          t(".review.#{action}"), send("review_#{action}_path", review.id),
          method: :put, class: "button #{action}_button"
        )
      end
      raw actions.join(' ')
    end
  end

  controller do
    %i(approve reject).each do |action|
      define_method action do
        Review.find(params[:review_id]).send(action.to_s << '!')
        redirect_to request.referrer
      end
    end
  end
end
