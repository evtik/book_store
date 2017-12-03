feature 'Admin Review index page' do
  include_examples 'not authorized', :admin_reviews_path

  let(:admin_user) { create(:admin_user) }
  let(:ar_prefix) { 'activerecord.attributes.review.state.' }
  let(:aa_prefix) { 'active_admin.resource.index.review.' }

  context 'with admin' do
    context 'reviews list' do
      let(:book) { create(:book_with_authors_and_materials) }

      background do
        Review.aasm.states.map(&:name).each_with_index do |state, index|
          create_list(:review, index + 1, book: book, user: admin_user,
                                          state: state)
        end
        login_as(admin_user, scope: :user)
        visit admin_reviews_path
      end

      scenario 'shows list of reviews with proper states' do
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

      context 'fiters' do
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

        scenario "click on 'unprocessed' filters out other reviews" do
          first('.table_tools_button', text: t("#{aa_prefix}unprocessed")).click
          [
            t("#{ar_prefix}rejected").upcase,
            t("#{ar_prefix}approved").upcase
          ].each { |state| expect(page).not_to have_text(state) }
        end

        scenario "click on 'approved' filters out other reviews" do
          first('.table_tools_button', text: t("#{aa_prefix}approved")).click
          [
            t("#{ar_prefix}unprocessed").upcase,
            t("#{ar_prefix}rejected").upcase
          ].each { |state| expect(page).not_to have_text(state) }
        end

        scenario "click on 'rejected' filters out other reviews" do
          first('.table_tools_button', text: t("#{aa_prefix}rejected")).click
          [
            t("#{ar_prefix}unprocessed").upcase,
            t("#{ar_prefix}approved").upcase
          ].each { |state| expect(page).not_to have_text(state) }
        end
      end
    end

    context 'aasm actions' do
      let(:book) { create(:book_with_authors_and_materials) }

      background { login_as(admin_user, scope: :user) }

      context "'unprocessed' review" do
        before do
          create(:review, book: book, user: admin_user, state: 'unprocessed')
          visit admin_reviews_path
        end

        scenario "click on 'approve' changes review state to 'approved'" do
          click_on(t("#{aa_prefix}approve"))
          expect(page).not_to have_text(t("#{ar_prefix}unprocessed").upcase)
          expect(page).not_to have_css('.button', text: t("#{aa_prefix}approve"))
          expect(page).to have_text(t("#{ar_prefix}approved").upcase)
        end

        scenario "click on 'reject' changes review state to 'rejected'" do
          click_on(t("#{aa_prefix}reject"))
          expect(page).not_to have_text(t("#{ar_prefix}unprocessed").upcase)
          expect(page).not_to have_css('.button', text: t("#{aa_prefix}reject"))
          expect(page).to have_text(t("#{ar_prefix}rejected").upcase)
        end
      end

      context "'approved' review" do
        before do
          create(:review, book: book, user: admin_user)
          visit admin_reviews_path
        end

        scenario "click on 'reject' changes review state to 'rejected'" do
          click_on(t("#{aa_prefix}reject"))
          expect(page).not_to have_text(t("#{ar_prefix}approved").upcase)
          expect(page).not_to have_css('.button', text: t("#{aa_prefix}reject"))
          expect(page).to have_text(t("#{ar_prefix}rejected").upcase)
        end
      end
    end
  end
end
