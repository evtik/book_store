FactoryGirl.define do
  factory :order_item do
    quantity 1

    factory :order_item_with_book_id do
      sequence(:book_id) { |n| n }
    end
  end
end
