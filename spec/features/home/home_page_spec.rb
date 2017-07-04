require 'factory_girl_rails'

feature 'Home page' do
  before do
    create_list(:book_with_authors_and_materials, 4)
  end

  background do
    visit root_path
  end

  scenario 'Visit home page' do
    expect(page).to have_content('Bookstore')
    # expect(page).to have_content('Foobar')
  end
end
