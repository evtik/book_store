feature 'Home page' do
  before do
    @books = create_list(:book_with_authors_and_materials, 4)
    visit root_path
  end

  scenario 'has brand' do
    expect(page).to have_css('.navbar-brand', text: 'Bookstore')
  end

  scenario 'has shop links' do
    expect(page).to have_link(t 'layouts.header.shop')
    expect(page).to have_link('Mobile Development')
    expect(page).to have_link('Web Development')
    expect(page).to have_link('Photo')
    expect(page).to have_link('Web Design')
  end

  context 'carousel slider' do
    scenario 'has newest 3 books' do
      expect(page).to have_css('.carousel-inner .item', count: 3)
    end

    scenario 'has newest book as active item' do
      expect(page).to have_css(
        '.carousel-inner .item.active h1', text: @books.last.title)
    end

    scenario 'sets other two slides to prelast and 3rd from end' do
      slides = all('.carousel-inner .item h1')
      2.times do |n|
        expect(slides[n + 1].text).to eq(@books.reverse[n + 1].title)
      end
    end

    scenario 'click on buy now adds book to cart' do
      first(:link, t('home.carousel_book.buy_now')).click
      expect(page).to have_css('.visible-xs .shop-quantity', text: '1')
      expect(page).to have_css('.hidden-xs .shop-quantity', text: '1')
    end
  end

  scenario 'get started navigates to catalog' do
    click_link(t 'home.index.get_started')
    expect(page).to have_css('h1', text: t('catalog.index.caption'))
  end

  context 'bestsellers' do
    scenario 'sorted by popularity'
    scenario 'click on view button navigates to book page'
    scenario 'click on cart button adds book to cart'
  end
end
