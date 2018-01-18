describe NotifierMailer, type: :mailer do
  let(:user) { create(:user) }

  context '#user_email' do
    let(:user_email) { NotifierMailer.user_email(user) }

    it 'after sign up sends email to signed up user' do
      expect(user_email.to).to include(user.email)
    end

    it 'has correct subject' do
      expect(user_email.subject).to include(
        t('notifier_mailer.user_email.subject', email: user.email)
      )
    end

    it 'has link to user settings in body' do
      expect(user_email.body.to_s).to include(settings_path)
    end
  end

  context '#order_email' do
    let(:order) do
      create(:book_with_authors_and_materials)
      order = build(:order, user: user)
      order.order_items << build(:order_item, book_id: 1)
      order.shipment = build(:shipment)
      order.subtotal = 5.0
      order.save
      order
    end

    let(:order_email) { NotifierMailer.order_email(order) }

    it 'after placing order sends confirmation email to user' do
      expect(order_email.to).to include(user.email)
    end

    it 'has correct subject' do
      expect(order_email.subject).to include(
        t('notifier_mailer.order_email.subject', number: order.decorate.number)
      )
    end

    it 'has link to order path in body' do
      expect(order_email.body.to_s).to include(order_path(order))
    end
  end
end
