FactoryGirl.define do
  factory :book do
    association :category, strategy: :build
    title { Faker::Book.title }
    year 2001
    description { Faker::Hipster.paragraph(5, false, 10) }
    height 10
    width 6
    thickness 1
    price 9.95
    main_image do
      Rack::Test::UploadedFile.new(
        File.join(Rails.root, 'spec', 'fixtures', '16.png'), 'image/png')
    end

    factory :book_with_authors_and_materials do
      transient do
        authors_count 2
        materials_count 2
      end

      after(:build) do |book, evaluator|
        book.authors << build_list(:author, evaluator.authors_count)
        book.materials << build_list(:material, evaluator.materials_count)
      end

      factory :book_with_order_items do
        transient do
          order_items_count 2
        end

        after(:build) do |book, evaluator|
          book.order_items << build_list(:order_item, evaluator.order_items_count)
        end
      end

      factory :book_with_reviews do
        transient do
          reviews_count 2
        end

        after(:build) do |book, evaluator|
          book.reviews << build_list(:review, evaluator.reviews_count)
        end
      end
    end
  end
end
