feature 'Admin edit Category page' do
  before { login_as(create(:admin_user), scope: :user) }

  background do
    create(:category)
    visit admin_book_categories_path
    click_link(t('active_admin.edit'))
  end

  scenario 'with valid category name shows success message' do
    fill_in('category_name', with: 'fantasy')
    click_on('Update Category')
    expect(page).to have_content(
      t('admin.book_categories.update.updated_message')
    )
  end

  scenario 'with invalid category name shows errors' do
    fill_in('category_name', with: '(***)')
    click_on('Update Category')
    expect(page).to have_content(t('errors.messages.invalid'))
  end
end
