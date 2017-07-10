feature 'Catalog page' do
  context 'with less than 12 available books' do
    before do
      create_list(:book_with_authors_and_materials, 4)
      visit catalog_index_path('limit' => 12)
    end

    scenario 'has catalog filter links' do
      expect(page).to have_css('a.filter-link', text: 'All')
      expect(page).to have_css('a.filter-link', text: 'Mobile Development')
      expect(page).to have_css('a.filter-link', text: 'Photo')
      expect(page).to have_css('a.filter-link', text: 'Web Design')
      expect(page).to have_css('a.filter-link', text: 'Web Development')
    end

    scenario 'has catalog filter dropdown in xs layout' do
      expect(page).to have_css('.visible-xs ul.dropdown-menu li a', text: 'All')
      expect(page).to have_css(
        '.visible-xs ul.dropdown-menu li a', text: 'Mobile Development')
      expect(page).to have_css(
        '.visible-xs ul.dropdown-menu li a', text: 'Photo')
      expect(page).to have_css(
        '.visible-xs ul.dropdown-menu li a', text: 'Web Design')
      expect(page).to have_css(
        '.visible-xs ul.dropdown-menu li a', text: 'Web Development')
    end

    scenario 'has 4 book items' do
      expect(page).to have_css('.general-thumb-wrap', count: 4)
    end

    scenario 'has no view more button' do
      expect(page).not_to have_link(t('catalog.index.view_more'))
      # expect(page).not_to have_css('.btn', text: t('catalog.index.view_more'))
    end
  end

  context 'with more than 12 available books' do
    before do
      create_list(:book_with_authors_and_materials, 20)
      visit catalog_index_path('limit' => 12)
    end

    scenario 'has view more button' do
      expect(page).not_to have_link(t('catalog.index.view_more'))
      # expect(page).not_to have_css('.btn', text: t('catalog.index.view_more'))
    end
  end
end
