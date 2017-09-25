require_relative '../../support/forms/login_form'

feature 'Login page' do
  given(:login_form) { LoginForm.new }

  background { create(:user, email: 'valid@example.com') }

  scenario 'with valid data' do
    create_list(:book_with_authors_and_materials, 4)
    login_form.visit_page.fill_in_with(
      email: 'valid@example.com',
      password: '11111111'
    ).submit
    expect(page).to have_content(t('devise.sessions.signed_in'))
  end

  scenario 'with empty email' do
    login_form.visit_page.fill_in_with(password: '11111111').submit
    expect(page).to have_content(
      t('devise.failure.invalid', authentication_keys: 'Email')
    )
  end

  scenario 'with non-existent email' do
    login_form.visit_page.fill_in_with(
      email: 'some_email@example.com',
      password: '11111111'
    ).submit
    expect(page).to have_content(
      t('devise.failure.invalid', authentication_keys: 'Email')
    )
  end

  scenario 'with empty password' do
    login_form.visit_page.fill_in_with(email: 'some_email@example.com').submit
    expect(page).to have_content(
      t('devise.failure.invalid', authentication_keys: 'Email')
    )
  end

  scenario 'with invalid password' do
    login_form.visit_page.fill_in_with(
      email: 'valid@example.com',
      password: '555'
    ).submit
    expect(page).to have_content(
      t('devise.failure.invalid', authentication_keys: 'Email')
    )
  end
end
