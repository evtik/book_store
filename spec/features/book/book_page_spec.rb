feature 'Book page' do
  context 'without reviews' do
    given!(:book) do
      create(
        :book_with_authors_and_materials,
        description: Faker::Hipster.paragraph(20)[0..990]
      )
    end

    background do
      visit book_path(book)
    end

    scenario 'has book title' do
      expect(page).to have_css('h1', text: book.title)
    end

    scenario 'has authors with their full names' do
      expect(page).to have_css(
        'p.in-grey-600.small', text: book.decorate.authors_full)
    end

    scenario 'has book price' do
      expect(page).to have_css('p.h1', text: book.price)
    end

    scenario 'has book publication year' do
      expect(page).to have_css('p.general-item-info', text: book.year)
    end

    scenario 'has book dimensions' do
      expect(page).to have_css(
        'p.general-item-info', text: book.decorate.dimensions)
    end

    scenario 'has book materials' do
      expect(page).to have_css(
        'p.general-item-info', text: book.decorate.materials_string)
    end

    context 'description' do
      scenario 'has description paragraph' do
        expect(page).to have_css(
          '#book-description', text: book.description[0..100])
      end

      scenario 'has read more button' do
        expect(page).to have_link(I18n.t('books.book_details.read_more'))
      end

      scenario 'when clicked read more link it shows read less' do
        click_link(I18n.t('books.book_details.read_more'))
        expect(page).to have_link(I18n.t('books.book_details.read_less'))
      end

      scenario 'has empty reviews header' do
        expect(page).to have_css(
          'h3', text: "#{I18n.t('books.book_reviews.reviews')} (0)")
      end
    end
  end

  context 'with reviews' do
  end
end
