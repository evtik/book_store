class NewReviewForm
  include AbstractController::Translation
  include FactoryGirl::Syntax::Methods
  include Capybara::DSL

  def visit_page
    click_on(t 'books.book_reviews.write_review')
    self
  end

  def fill_in_with(params = attributes_for(:review))
    find("#star-#{params.fetch(:score)}").click
    fill_in('review_title', with: params.fetch(:title))
    fill_in('review_body', with: params.fetch(:body))
    self
  end

  def submit
    click_on(t 'reviews.form.post')
  end
end
