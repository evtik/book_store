require_relative '../../../support/admin/batch_actions'

feature 'Admin Books index page' do
  include BatchActionsHelpers

  include_examples 'not authorized', :admin_books_path

  context 'with admin' do
    given(:admin_user) { create(:admin_user) }
    given(:book_label) { t('activerecord.models.book.one') }
    given(:books_label) { t('activerecord.models.book.other') }

    background do
      login_as(admin_user, scope: :user)
    end

    scenario 'shows admin books index' do
      visit admin_books_path
      expect(page).to have_content(books_label)
      expect(page).to have_link(t('active_admin.new_model',
                                  model: book_label))
    end

    scenario 'shows list of available books' do
      create_list(:book_with_authors_and_materials, 3, title: 'Thetis')
      visit admin_books_path
      expect(page).to have_content('Thetis', count: 3)
    end

    scenario "click on 'new book' redirects to 'new book' page" do
      visit admin_books_path
      click_link(t('active_admin.new_model', model: book_label))
      expect(page).to have_content(
        t('active_admin.new_model', model: book_label)
      )
      expect(page).to have_field('book_title')
    end

    scenario "click on 'view' link redirects to 'show book' page" do
      create(:book_with_authors_and_materials, title: 'Dwarf')
      visit admin_books_path
      click_link(t('active_admin.view'))
      expect(page).to have_content('Dwarf')
      expect(page).to have_link(t('active_admin.edit_model',
                                  model: book_label))
      expect(page).to have_link(t('active_admin.delete_model',
                                  model: book_label))
    end

    scenario "click on 'edit' link redirects to 'edit book' page" do
      create(:book_with_authors_and_materials)
      visit admin_books_path
      click_link(t('active_admin.edit'))
      expect(page).to have_content(
        t('active_admin.edit_model', model: book_label)
      )
      expect(page).to have_field('book_year')
    end

    scenario "click on 'delete' removes book from list", use_selenium: true do
      create(:book_with_authors_and_materials)
      visit admin_books_path
      click_link(t('active_admin.delete'))
      accept_alert
      expect(page).to have_content(
        t('active_admin.blank_slate.content', resource_name: books_label)
      )
    end

    context 'batch actions', use_selenium: true do
      scenario 'delete all' do
        create_list(:book_with_authors_and_materials, 3)
        visit admin_books_path
        check_batch_all
        click_batch_delete
        expect(page).to have_content(
          batch_destroyed_label(3, books_label.downcase)
        )
        expect(page).to have_content(
          t('active_admin.blank_slate.content', resource_name: books_label)
        )
      end

      scenario 'delete selected' do
        create_list(:book_with_authors_and_materials, 4, title: 'Troy')
        visit admin_books_path
        check_batch_items(1, 3)
        click_batch_delete
        expect(page).to have_content(
          batch_destroyed_label(2, books_label.downcase)
        )
        expect(page).to have_content('Troy', count: 2)
      end
    end
  end
end
