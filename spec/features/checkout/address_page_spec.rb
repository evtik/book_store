require_relative '../../support/forms/new_address_form'

feature 'Checkout address page' do
  context 'with guest user' do
    it 'redirects to login page' do
      visit checkout_address_path
      expect(page).to have_content(t 'devise.failure.unauthenticated')
    end
  end

  context 'with logged in user' do
    context 'with empty cart' do
      it 'has cart empty message' do
        login_as(create(:user), scope: :user)
        visit checkout_address_path
        expect(page).to have_content(
          t('cart.index.cart_empty_html',
            href: (t 'catalog.index.caption')
           )
         )
      end
    end

    context 'with items in cart' do
      around do |example|
        login_as(create(:user), scope: :user)
        create_list(:book_with_authors_and_materials, 3)
        page.set_rack_session(
          cart: { 1 => 1, 2 => 2, 3 => 3 },
          items_total: 6.00,
          order_subtotal: 5.40
        )
        visit checkout_address_path
        example.run
        page.set_rack_session(cart: nil, items_total: nil, order_subtotal: nil)
      end

      scenario 'has 1 as current checkout progress step' do
        expect(page).not_to have_css('li.step.done')
        expect(page).to have_css(
          'li.step.active span.step-number', text: '1')
      end

      scenario 'has addresses headers' do
        expect(page).to have_css(
          'h3.general-subtitle', text: t('checkout.address.billing_address'))
        expect(page).to have_css(
          'h3.general-subtitle', text: t('checkout.address.shipping_address'))
      end

      scenario 'has correct totals' do
        expect(page).to have_css('p.font-16', text: '6.00')
        expect(page).to have_css('p.font-16', text: '5.40')
      end

      context 'filling in addresses' do
       context 'billing' do
         given(:billing_address_form) do
           NewAddressForm.new('order', 'billing')
         end

         scenario 'with valid data' do
          billing_address_form.fill_in_form(
            attributes_for(:address, city: 'Billburg',
                           phone: '+1234567891011'))
         end
       end
      end
    end
  end
end
