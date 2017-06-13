ActiveAdmin.register Review do
  config.batch_actions = true
  config.filters = false

  scope :all, default: true
  scope :unprocessed
  scope :approved
  scope :rejected

  index do
    selectable_column
    column :id
    column('Book') { |review| review.book.title }
    column 'Date', :created_at
    column('User') { |review| review.user.email }
    state_column :state
    column 'Actions' do |review|
      actions = %w(approve reject).map do |action|
        next unless review.send("may_#{action}?")
        link_to(
          action.humanize, send("review_#{action}_path", review.id),
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
