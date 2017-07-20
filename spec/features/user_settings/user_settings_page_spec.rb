require_relative '../../support/forms/new_address_form'

feature 'User settings page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit user_settings_path(1)
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    given!(:user) { create(:user) }

    context 'addresses' do
      given(:billing_form) { NewAddressForm.new('address', 'billing') }
      given(:shipping_form) { NewAddressForm.new('address', 'shipping') }

      before do
        login_as(user, scope: :user)
        visit user_settings_path(user)
      end

      context 'filling in billing address' do
        scenario 'with valid data shows updated message' do
          billing_form.fill_in_form(attributes_for(:address,
                                                   country: 'Portugal'))
          first("input[type='submit']").click
          expect(page).to have_content(
            t('user_settings.show.address_saved', address_type: 'billing')
          )
        end
      end
    end

    context 'privacy' do
    end
  end
end
