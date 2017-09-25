feature 'Cart page' do
  context 'empty cart' do
    it 'has cart empty message' do
      visit cart_index_path
      expect(page).to have_content(
        t('cart.index.cart_empty_html', href: (t 'catalog.index.caption'))
      )
    end
  end

  context 'cart with items' do
    around do |example|
      @books = create_list(:book_with_authors_and_materials, 3)
      page.set_rack_session(cart: { 1 => 1, 2 => 2, 3 => 3 })
      visit cart_index_path
      example.run
      page.set_rack_session(cart: nil)
    end

    scenario 'has correct number of books on cart icon' do
      expect(page).to have_css(
        '.visible-xs .shop-quantity',
        visible: false, text: '3'
      )
      expect(page).to have_css('.hidden-xs .shop-quantity', text: '3')
    end

    scenario 'has books in cart' do
      expect(page).to have_css('p.general-title', count: 3)
      expect(first('p.general-title').text).to eq(@books.first.title)
    end

    scenario 'has correct totals' do
      expect(page).to have_css('p.font-16', text: '6.00')
      expect(page).to have_css('strong.font-18', text: '6.00')
    end

    context 'input controls' do
      scenario 'click plus button adds 1 to book quantity' do
        first('a.quantity-increment').click
        expect(find_field("quantities-#{@books.first.id}").value).to eq('2')
        expect(find_field("xs-quantities-#{@books.first.id}",
                          visible: false).value).to eq('2')
      end

      context 'click minus button' do
        scenario 'does not subtract 1 from quantity if it is 1' do
          first('a.quantity-decrement').click
          expect(find_field("quantities-#{@books.first.id}").value).to eq('1')
          expect(find_field("xs-quantities-#{@books.first.id}",
                            visible: false).value).to eq('1')
        end

        scenario 'subtract 1 from quantity if it is greater than 1' do
          all('a.quantity-decrement')[1].click
          expect(find_field("quantities-#{@books.second.id}").value).to eq('1')
          expect(find_field("xs-quantities-#{@books.second.id}",
                            visible: false).value).to eq('1')
        end
      end

      scenario 'click on close button removes book from cart' do
        all('a.close.general-cart-close').last.click
        accept_alert
        expect(page).to have_css('p.general-title', count: 2)
        expect(page).to have_css('strong.font-18', text: '3.00')
        expect(page).to have_css(
          '.visible-xs .shop-quantity',
          visible: false, text: '2'
        )
        expect(page).to have_css('.hidden-xs .shop-quantity', text: '2')
      end
    end

    context 'filling in coupon code' do
      scenario 'with non-existent code' do
        fill_in('coupon', with: 'aslkd')
        click_on(t('cart.index.update_cart'))
        expect(page).to have_content(t('coupon.non_existent'))
      end

      scenario 'with expired coupon' do
        create(:coupon, expires: Date.today - 1.day)
        fill_in('coupon', with: '123456')
        click_on(t('cart.index.update_cart'))
        expect(page).to have_content(t('coupon.expired'))
      end

      scenario 'with coupon been already taken' do
        create(:coupon_with_order)
        fill_in('coupon', with: '123456')
        click_on(t('cart.index.update_cart'))
        expect(page).to have_content(t('coupon.taken'))
      end

      scenario 'with valid coupon' do
        create(:coupon)
        fill_in('coupon', with: '123456')
        click_on(t('cart.index.update_cart'))
        expect(page).to have_css('p.font-16', text: '6.00')
        expect(page).to have_css('p.font-16', text: '0.60')
        expect(page).to have_css('strong.font-18', text: '5.40')
      end
    end
  end

  context 'proceed to checkout' do
    around do |example|
      create_list(:book_with_authors_and_materials, 3)
      page.set_rack_session(cart: { 1 => 1, 2 => 2, 3 => 3 })
      example.run
      page.set_rack_session(cart: nil)
    end

    scenario 'with guest user redirects to login page' do
      visit cart_index_path
      click_on(t('cart.index.checkout'))
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end

    scenario 'with logged in user redirets to checkout address' do
      user = create(:user)
      login_as(user, scope: :user)
      visit cart_index_path
      click_on(t('cart.index.checkout'))
      expect(page).to have_css('h1', text: t('checkout.caption'))
    end
  end
end
