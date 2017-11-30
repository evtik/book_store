shared_examples 'not authorized' do |path|
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit send(path)
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with non-admin user' do
    scenario "redirects back to root with 'not authorized' message" do
      create_list(:book_with_authors_and_materials, 3)
      login_as(create(:user), scope: :user)
      visit send(path)
      expect(page).to have_content(t('admin.not_authorized'))
    end
  end
end
