feature 'Admin Categories index page' do
  include_examples 'not authorized', :admin_book_categories_path

  context 'with admin' do
    given(:admin_user) { create(:admin_user) }
    given(:category_label) { 'Book ' + t('activerecord.models.category.one') }
    given(:categories_label) do
      'Book ' + t('activerecord.models.category.other')
    end

    background do
      login_as(admin_user, scope: :user)
    end

    scenario 'shows admin categories index' do
      visit admin_book_categories_path
      expect(page).to have_content(categories_label)
      expect(page).to have_link(t('active_admin.new_model',
                                  model: category_label))
    end

    scenario 'shows list of available categories' do
      create_list(:category, 4, name: 'Fiction')
      visit admin_book_categories_path
      expect(page).to have_content('Fiction', count: 4)
    end

    scenario "click on 'new category' redirects to 'new category' page" do
      visit admin_book_categories_path
      click_link(t('active_admin.new_model', model: category_label))
      expect(page).to have_content(
        t('active_admin.new_model', model: category_label)
      )
      expect(page).to have_field('category_name')
    end

    scenario "click on 'view' link redirects to 'show category' page" do
      category = create(:category)
      visit admin_book_categories_path
      click_link(t('active_admin.view'))
      sleep 15
      expect(page).to have_content(category.name)
      expect(page).to have_link(t('active_admin.edit_model',
                                  model: category_label))
      expect(page).to have_link(t('active_admin.delete_model',
                                  model: category_label))
    end

    scenario "click on 'edit' link redirects to 'edit category' page" do
      create(:category)
      visit admin_book_categories_path
      click_link(t('active_admin.edit'))
      expect(page).to have_content(
        t('active_admin.edit_model', model: category_label)
      )
      expect(page).to have_field('category_name')
    end

    scenario "click on 'delete' removes category from list" do
      create(:category)
      visit admin_book_categories_path
      click_link(t('active_admin.delete'))
      accept_alert
      expect(page).to have_content(
        t('active_admin.blank_slate.content', resource_name: categories_label)
      )
    end

    context 'batch actions' do
      scenario 'delete all' do
        create_list(:category, 5)
        visit admin_book_categories_path
        check('collection_selection_toggle_all')
        click_link(t('active_admin.batch_actions.button_label'))
        click_link(t('active_admin.batch_actions.action_label',
                     title: t('active_admin.batch_actions.labels.destroy')))
        click_button('OK')
        expect(page).to have_content(
          t('active_admin.batch_actions.succesfully_destroyed.other',
            count: 5,
            plural_model: categories_label.downcase)
        )
        expect(page).to have_content(
          t('active_admin.blank_slate.content', resource_name: categories_label)
        )
      end

      scenario 'delete selected' do
        create_list(:category, 4, name: 'Sports')
        visit admin_book_categories_path
        check('batch_action_item_1')
        check('batch_action_item_3')
        click_link(t('active_admin.batch_actions.button_label'))
        click_link(t('active_admin.batch_actions.action_label',
                     title: t('active_admin.batch_actions.labels.destroy')))
        click_button('OK')
        expect(page).to have_content(
          t('active_admin.batch_actions.succesfully_destroyed.other',
            count: 2,
            plural_model: categories_label.downcase)
        )
        expect(page).to have_content('Sports', count: 2)
      end
    end
  end
end
