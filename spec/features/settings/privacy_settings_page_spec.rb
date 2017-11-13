require_relative '../../support/forms/new_password_form'

feature 'User privacy settings page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit settings_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    given!(:user) { create(:user) }

    before do
      login_as(user, scope: :user)
      visit settings_path
      click_on(t('settings.show.privacy'))
    end

    context 'update email' do
      scenario 'with vaild email' do
        fill_in('user[email]', with: 'user2@example.com')
        click_on(t('settings.show.save'))
        expect(page).to have_content(
          t('settings.change_email.email_updated')
        )
      end

      scenario 'with email taken by another user' do
        another_user = create(:user)
        fill_in('user[email]', with: another_user.email)
        click_on(t('settings.show.save'))
        expect(page).to have_content(t('errors.messages.taken'))
      end
    end

    context 'update password' do
      given(:password_form) { NewPasswordForm.new }

      scenario 'with valid data' do
        password_form.fill_in_with(
          current_password: '11111111',
          password: '22222222',
          password_confirmation: '22222222'
        ).submit
        expect(page).to have_content(
          t('settings.change_password.changed_message')
        )
      end

      scenario 'with password not matching password confirmation' do
        password_form.fill_in_with(
          current_password: '11111111',
          password: '22222222',
          password_confirmation: '33333333'
        ).submit
        expect(page).to have_content(
          t('errors.messages.confirmation', attribute: 'Password')
        )
      end

      scenario 'with too short password' do
        password_form.fill_in_with(
          current_password: '11111111',
          password: '22',
          password_confirmation: '22'
        ).submit
        expect(page).to have_content(
          t('errors.messages.too_short.other', count: 6)
        )
      end

      scenario 'with current password invalid' do
        password_form.fill_in_with(
          current_password: '123',
          password: '22222222',
          password_confirmation: '22222222'
        ).submit
        expect(page).to have_content(
          t('errors.messages.invalid')
        )
      end

      scenario 'with current password blank' do
        password_form.fill_in_with(
          password: '22222222',
          password_confirmation: '22222222'
        ).submit
        expect(page).to have_content(
          t('errors.messages.blank')
        )
      end
    end

    scenario 'remove account' do
      create_list(:book_with_authors_and_materials, 4)
      find('i.fa-check').click
      click_on(t('settings.remove_account.label'))
      accept_alert
      expect(page).to have_content(
        t('settings.remove_account.removed_message')
      )
    end
  end
end
