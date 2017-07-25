class SignupForm
  include AbstractController::Translation
  include Capybara::DSL

  def fill_in_with(params)
    fill_in('user[email]', with: params[:email])
    fill_in('user[password]', with: params[:password])
    fill_in('user[password_confirmation]', with: params[:password_confirmation])
    self
  end

  def submit
    click_on(t('devise.registrations.new.sign_up'))
  end
end
