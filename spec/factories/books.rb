FactoryGirl.define do
  factory :book do
    category
    title { Faker::Book.title }
    year 2001
    description { Faker::Hipster.paragraph(5, false, 10) }
    height 10
    width 6
    thickness 1
    price 9.95
    main_image { Rack::Test::UploadedFile.new(
                          File.join(Rails.root, 'spec', 'support', 'books', 'main_images', '16.png'), 'image/png') }

    factory :book_with_authors_and_materials do
      transient do
        authors_count 2
        materials_count 2
      end

      after(:build) do |book, evaluator|
        book.authors << build_list(:author, evaluator.authors_count)
        book.materials << build_list(:material, evaluator.materials_count)
      end
    end
  end
end
