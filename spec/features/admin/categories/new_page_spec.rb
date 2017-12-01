feature 'Admin new Category page' do
  before { login_as(create(:admin_user), scope: :user) }

  background do
    visit admin_book_categories_path
    click_on(t('active_admin.new_model',
               model: 'Book ' + t('activerecord.models.category.one')))
  end

  scenario 'with valid category name shows success message' do
    fill_in('category_name', with: 'horror')
    click_on('Create Category')
    expect(page).to have_content(
      t('admin.book_categories.create.created_message')
    )
  end

  scenario 'with invalid category name shows errors' do
    click_on('Create Category')
    expect(page).to have_content(t('errors.messages.blank'))
  end
end
