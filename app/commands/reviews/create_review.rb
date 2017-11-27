module Reviews
  class CreateReview < BaseCommand
    def call(params, user)
      review_form = ReviewForm.from_params(params)
      if review_form.invalid?
        publish(:invalid, review_form,
                BookWithAssociated.new(params[:book_id]).first.decorate)
      else
        review = Review.new(review_form.attributes.merge(user: user))
        return publish(:error, review.errors.full_messages[0]) unless review.save
        publish(:ok, I18n.t('reviews.form.success_message'))
      end
    end
  end
end
