ActiveAdmin.register Review do
  actions :index, :show

  config.filters = false

  scope I18n.t('.active_admin.resource.index.all'), :all, default: true
  scope I18n.t('.active_admin.resource.index.review.unprocessed'), :unprocessed
  scope I18n.t('.active_admin.resource.index.review.approved'), :approved
  scope I18n.t('.active_admin.resource.index.review.rejected'), :rejected

  index do
    column(t('.review.book')) do |review|
      link_to review.book.title, admin_book_path(review.book)
    end
    column(t('.review.title')) do |review|
      link_to(markdown_truncate(review.title, length: 30),
              admin_review_path(review))
    end
    column(t('.review.body')) do |review|
      markdown_truncate(review.body, length: 90)
    end
    column t('.review.date'), :created_at
    column(t('.review.user')) do |review|
      link_to review.user.email, admin_user_path(review.user)
    end
    state_column t('.review.state'), :state
    column(t('.actions')) { |review| review_aasm_links(review) }
  end

  show do
    attributes_table do
      state_row t('.review.state'), :state
      row t('activerecord.models.user.one') do |review|
        link_to review.user.email, admin_user_path(review.user)
      end
      row(t('activerecord.models.book.one')) do |review|
        link_to review.book.title, admin_book_path(review.book)
      end
      row(:title) { |review| h4 review.title }
      row(:body, &:body)
      row(t('.actions')) { |review| review_aasm_links(review) }
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
