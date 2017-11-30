require_relative '../../../support/forms/admin_author_form'

feature 'Admin edit Author page' do
  before { login_as(create(:admin_user), scope: :user) }

  given(:form) { AdminAuthorForm.new }

  background do
    create(:author)
    visit admin_authors_path
    click_link(t('active_admin.edit'))
  end

  scenario 'with valid author data shows success message' do
    form.fill_in_with(attributes_for(:author)).submit('Update')
    expect(page).to have_content(t('admin.authors.update.updated_message'))
  end

  scenario 'with invalid author data shows errors' do
    form.fill_in_with(attributes_for(:author, first_name: '')).submit('Update')
    expect(page).to have_content(t('errors.attributes.first_name.blank'))
  end
end
