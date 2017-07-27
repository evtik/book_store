describe Book do
  context 'association' do
    it { is_expected.to have_and_belong_to_many(:authors) }
    it { is_expected.to have_and_belong_to_many(:materials) }
    it { is_expected.to have_many(:order_items).dependent(:destroy) }
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
    it { is_expected.to have_many(:approved_reviews) }
    it { is_expected.to accept_nested_attributes_for(:authors) }
  end

  context 'title' do
    include_examples 'title'
  end

  context 'description' do
    include_examples 'description', :description
  end

  context 'year' do
    it do
      is_expected.to(validate_numericality_of(:year)
        .only_integer
        .is_greater_than(1990)
        .is_less_than_or_equal_to(Date.today.year))
    end
  end

  context 'height' do
    it do
      is_expected.to(validate_numericality_of(:height)
        .is_greater_than(7).is_less_than(16))
    end
  end

  context 'width' do
    it do
      is_expected.to(validate_numericality_of(:width)
        .is_greater_than(3)
        .is_less_than(8))
    end
  end

  context 'thickness' do
    it do
      is_expected.to(validate_numericality_of(:thickness)
        .is_greater_than(0)
        .is_less_than(4))
    end
  end

  context 'custom validators' do
    context 'must have category' do
      it 'book without category is invalid' do
        book = build(:book, category: nil)
        book.valid?
        expect(book.errors[:base]).to include('Must have a category')
      end

      it 'book with category is valid' do
        book = build(:book)
        book.valid?
        expect(book.errors[:base]).not_to include('Must have a category')
      end
    end

    context 'must have authors' do
      it 'book without authors is invalid' do
        book = build(:book)
        book.valid?
        expect(book.errors[:base]).to include('Must be at least one author')
      end

      it 'book with authors is valid' do
        book = build(:book)
        book.authors << build(:author)
        book.valid?
        expect(book.errors[:base]).not_to include('Must be at least one author')
      end
    end

    context 'must have materials' do
      it 'book without materials is invalid' do
        book = build(:book)
        book.valid?
        expect(book.errors[:base]).to include('Must be at least one material')
      end

      it 'book with materials is valid' do
        book = build(:book)
        book.materials << build(:material)
        book.valid?
        expect(book.errors[:base]).not_to include(
          'Must be at least one material'
        )
      end
    end
  end
end
