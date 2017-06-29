require 'factory_girl_rails'

feature 'Home page' do
  before do
    4.times { FactoryGirl.create(:category) }
  end

  scenario 'Visit home page' do
    visit '/'
    expect(page).to have_content('Foobar')
  end
end
