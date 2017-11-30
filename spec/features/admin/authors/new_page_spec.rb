require_relative '../../../support/forms/admin_author_form'

feature 'Admin new Author page' do
  before { login_as(create(:admin_user), scope: :user) }

  given(:form) { AdminAuthorForm.new }

  background do
    visit admin_authors_path
    click_on(t('active_admin.new_model',
               model: t('activerecord.models.author.one')))
  end

  scenario 'with valid author data shows success message' do
    form.fill_in_with(attributes_for(:author)).submit('Create')
    expect(page).to have_content(t('admin.authors.create.created_message'))
  end

  scenario 'with valid author data and db error shows error message' do
    allow_any_instance_of(Author).to receive(:save).and_return(false)
    error_message = 'some db error...'
    allow_any_instance_of(Author).to receive_message_chain(
      :errors, full_messages: [error_message]
    )
    form.fill_in_with(attributes_for(:author)).submit('Create')
    expect(page).to have_content(error_message)
  end

  scenario 'with invalid author data shows errors' do
    form.fill_in_with(attributes_for(:author, last_name: '#@!})'))
        .submit('Create')
    expect(page).to have_content(t('errors.messages.invalid'))
  end
end
