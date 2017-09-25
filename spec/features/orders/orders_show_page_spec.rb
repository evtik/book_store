feature 'Orders show page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit user_order_path(id: 1, order_id: 1)
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    given!(:user) { create(:user) }
    given!(:books) { create_list(:book_with_authors_and_materials, 3) }
    given!(:order) do
      order = build(:order, user: user)
      3.times do |index|
        order.order_items << build(:order_item, book_id: (index + 1))
      end
      order.shipment = build(:shipment)
      order.subtotal = 5.4
      order.credit_card = build(:credit_card)
      order.addresses << build(:address)
      order.addresses << build(:address, address_type: 'shipping',
                                         country: 'Spain')
      order.save
      order
    end

    background { login_as(user, scope: :user) }

    context 'order details' do
      background do
        visit user_order_path(user, order)
      end

      scenario 'has order number' do
        expect(page).to have_css('h1', text: 'R00000001')
      end

      include_examples 'order details'
      include_examples 'extended order details'
    end

    context "trying to access other user's order" do
      given!(:another_order) { create(:order, user: create(:user)) }

      scenario "redirects to 'not authorized' page" do
        visit user_order_path(user, another_order)
        expect(page).to have_content(
          'You are not authorized to access this resource (403)'
        )
      end
    end
  end
end
