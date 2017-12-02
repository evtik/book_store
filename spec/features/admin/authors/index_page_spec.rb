require_relative '../../../support/admin/batch_actions'

feature 'Admin Authors index page' do
  include BatchActionsHelpers

  include_examples 'not authorized', :admin_authors_path

  context 'with admin' do
    given(:admin_user) { create(:admin_user) }
    given(:author_label) { t('activerecord.models.author.one') }
    given(:authors_label) { t('activerecord.models.author.other') }

    background do
      login_as(admin_user, scope: :user)
    end

    scenario 'shows admin authors index' do
      visit admin_authors_path
      expect(page).to have_content(authors_label)
      expect(page).to have_link(t('active_admin.new_model',
                                  model: author_label))
    end

    scenario 'shows list of available authors' do
      create_list(:author, 5, first_name: 'Samuel')
      visit admin_authors_path
      expect(page).to have_content('Samuel', count: 5)
    end

    scenario "click on 'new author' redirects to 'new author' page" do
      visit admin_authors_path
      click_link(t('active_admin.new_model', model: author_label))
      expect(page).to have_content(
        t('active_admin.new_model', model: author_label)
      )
      expect(page).to have_field('author_first_name')
    end

    scenario "click on 'view' link redirects to 'show author' page" do
      create(:author)
      visit admin_authors_path
      click_link(t('active_admin.view'))
      expect(page).to have_content("#{author_label} #1")
      expect(page).to have_link(t('active_admin.edit_model',
                                  model: author_label))
      expect(page).to have_link(t('active_admin.delete_model',
                                  model: author_label))
    end

    scenario "click on 'edit' link redirects to 'edit author' page" do
      create(:author)
      visit admin_authors_path
      click_link(t('active_admin.edit'))
      expect(page).to have_content(
        t('active_admin.edit_model', model: author_label)
      )
      expect(page).to have_field('author_last_name')
    end

    scenario "click on 'delete' removes author from list" do
      create(:author)
      visit admin_authors_path
      click_link(t('active_admin.delete'))
      accept_alert
      expect(page).to have_content(
        t('active_admin.blank_slate.content', resource_name: authors_label)
      )
    end

    context 'batch actions' do
      scenario 'delete all' do
        create_list(:author, 7)
        visit admin_authors_path
        check_batch_all
        click_batch_delete
        expect(page).to have_content(
          batch_destroyed_label(7, authors_label.downcase)
        )
        expect(page).to have_content(
          t('active_admin.blank_slate.content', resource_name: authors_label)
        )
      end

      scenario 'delete selected' do
        create_list(:author, 5, last_name: 'Swail')
        visit admin_authors_path
        check_batch_items(2, 4)
        click_batch_delete
        expect(page).to have_content(
          batch_destroyed_label(2, authors_label.downcase)
        )
        expect(page).to have_content('Swail', count: 3)
      end
    end
  end
end
