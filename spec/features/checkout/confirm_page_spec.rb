feature 'Checkout confirm page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit checkout_payment_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    given!(:user) { create(:user) }
    given!(:books) { create_list(:book_with_authors_and_materials, 3) }

    around do |example|
      login_as(user, scope: :user)
      page.set_rack_session(
        cart: { 1 => 1, 2 => 2, 3 => 3 },
        order: {
          billing: attributes_for(:address),
          shipping: attributes_for(:address, address_type: 'shipping'),
          shipment: attributes_for(:shipment),
          subtotal: 5.4
        }
      )
      example.run
      page.set_rack_session(order: nil)
    end

    context 'with no credit card set' do
      scenario 'redirects to checkout payment path' do
        visit checkout_confirm_path
        expect(page).to have_css(
          'h3.general-subtitle', text: t('checkout.payment.credit_card')
        )
      end
    end

    context 'with credit card set' do
      background do
        page.set_rack_session(
          order: {
            billing: attributes_for(:address),
            shipping: attributes_for(:address, address_type: 'shipping'),
            shipment: attributes_for(:shipment),
            shipment_id: 1,
            card: attributes_for(:credit_card),
            subtotal: 5.4
          }
        )
      end

      scenario 'has 4 as current checkout progress step' do
        visit checkout_confirm_path
        expect(page).to have_css('li.step.done', count: 3)
        expect(page).to have_css('li.step.active span.step-number', text: '4')
      end

      scenario 'has addresses' do
        visit checkout_confirm_path
        expect(page).to have_css(
          'h3.general-subtitle',
          text: t('checkout.address.billing_address')
        )
        expect(page).to have_css(
          'h3.general-subtitle',
          text: t('checkout.address.shipping_address')
        )
        expect(page).to have_css(
          'p.general-address', text: 'Italy', count: 2
        )
      end

      scenario 'has addresses edit link' do
        visit checkout_confirm_path
        expect(page).to have_link('edit', href: checkout_address_path)
      end

      scenario 'has shipment' do
        visit checkout_confirm_path
        expect(page).to have_css(
          'h3.general-subtitle',
          text: t('checkout.shipments')
        )
        expect(page).to have_content('Delivery method #')
      end

      scenario 'has shipment edit link' do
        visit checkout_confirm_path
        expect(page).to have_link('edit', href: checkout_delivery_path)
      end

      scenario 'has payment info' do
        visit checkout_confirm_path
        expect(page).to have_css(
          'h3.general-subtitle',
          text: t('checkout.payment_info')
        )
        expect(page).to have_content('** ** ** 4647')
      end

      scenario 'has payment edit link' do
        visit checkout_confirm_path
        expect(page).to have_link('edit', href: checkout_payment_path)
      end

      scenario 'has books list' do
        visit checkout_confirm_path
        expect(page).to have_css('p.general-title', count: 3)
        expect(first('p.general-title').text).to eq(books.first.title)
      end

      scenario 'has no input controls' do
        visit checkout_confirm_path
        expect(page).to_not have_css('a.close.general-cart-close')
        expect(page).to_not have_css("input[type='text']")
        expect(page).to_not have_css('.quantity_increment')
        expect(page).to_not have_css('.quantity_decrement')
      end

      scenario 'has totals and shipment' do
        visit checkout_confirm_path
        expect(page).to have_css('p.font-16', text: '5.40')
        expect(page).to have_css('p#shipment-label', text: '5.00')
        expect(page).to have_css('strong#order-total-label', text: '10.40')
      end

      scenario 'click on place order redirects to order complete page' do
        create(:shipment)
        visit checkout_confirm_path
        click_on(t('checkout.confirm.place_order'))
        expect(page).to have_css(
          'h3.general-subtitle',
          text: t('checkout.complete.thanks')
        )
      end
    end
  end
end
