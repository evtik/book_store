feature 'Admin Review index page' do
  include_context 'aasm review variables'

  include_examples 'not authorized', :admin_reviews_path

  let(:admin_user) { create(:admin_user) }

  context 'with admin' do
    context 'reviews list' do
      let(:book) { create(:book_with_authors_and_materials) }

      background do
        aasm_states.each_with_index do |state, index|
          create_list(:review, index + 1, book: book, user: admin_user,
                                          state: state)
        end
        login_as(admin_user, scope: :user)
        visit admin_reviews_path
      end

      scenario 'shows list of reviews with proper states', use_selenium: true do
        {
          book.title => 6,
          t("#{ar_prefix}rejected").upcase => 3,
          t("#{ar_prefix}approved").upcase => 2,
          t("#{ar_prefix}unprocessed").upcase => 1
        }.each { |key, value| expect(page).to have_text(key, count: value) }
      end

      scenario 'shows proper state change buttons' do
        {
          t("#{aa_prefix}reject") => 3,
          t("#{aa_prefix}approve") => 1
        }.each do |key, value|
          expect(page).to have_css('.button', text: key, count: value)
        end
      end

      context 'filters' do
        scenario 'shows review list filters' do
          [
            'All (6)',
            t("#{aa_prefix}rejected") + ' (3)',
            t("#{aa_prefix}approved") + ' (2)',
            t("#{aa_prefix}unprocessed") + ' (1)'
          ].each do |text|
            expect(page).to have_css('.table_tools_button', text: text)
          end
        end

        include_examples 'active admin filters',
                         filters: %i(unprocessed approved rejected),
                         entity: :reviews
      end
    end

    context 'aasm actions' do
      background { login_as(admin_user, scope: :user) }

      params = AASMHelper.review_config.merge(
        path_helper: :admin_reviews_path,
        resource_path: false
      )

      include_examples 'aasm actions', params do
        given(:entity) do
          create(:review, book: build(:book_with_authors_and_materials),
                          user: admin_user)
        end
      end
    end
  end
end
