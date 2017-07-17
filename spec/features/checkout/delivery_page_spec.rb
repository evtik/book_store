feature 'Checkout delivery page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit checkout_delivery_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    around do |example|
      login_as(create(:user), scope: :user)
      create_list(:book_with_authors_and_materials, 3)
      page.set_rack_session(
        cart: { 1 => 1, 2 => 2, 3 => 3 },
        items_total: 6.00,
        order_subtotal: 5.40
      )
      example.run
      page.set_rack_session(
        cart: nil, items_total: nil,
        order_subtotal: nil, order: nil
      )
    end

    context 'with no order addresses' do
      scenario 'redirects to checkout address step' do
        visit checkout_delivery_path
        expect(page).to have_css(
          'h3.general-subtitle', text: t('checkout.address.billing_address')
        )
      end
    end

    context 'with addresses set' do
      background do
        create_list(:shipment, 3)
        page.set_rack_session(
          order: {
            billing: attributes_for(:address),
            items_total: 6.0,
            subtotal: 5.4
          }
        )
      end

      scenario 'has 2 as current checkout progress step' do
        visit checkout_delivery_path
      end
    end
  end
end
