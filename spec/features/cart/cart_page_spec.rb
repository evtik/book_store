feature 'Cart page' do
  # given!(:books) { create_list(:book_with_authors_and_materials, 3) }

  around do |example|
    @books = create_list(:book_with_authors_and_materials, 3)
    page.set_rack_session(cart: { 1 => 1, 2 => 2, 3 => 3 })
    visit cart_index_path
    example.run
    page.set_rack_session(cart: nil)
  end

  scenario 'has books in cart' do
    expect(page).to have_css('p.general-title', count: 3)
    expect(first('p.general-title').text).to eq(@books.first.title)
  end
end
