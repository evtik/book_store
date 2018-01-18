FactoryGirl.define do
  factory :order_item do
    quantity 1

    factory :order_item_with_book_id do
      sequence(:book_id) { |n| n }
    end

    factory :order_item_with_book_id_cycled do
      ids = [*1..4]
      sequence(:book_id) { |n| ids[(n - 1) % ids.length] }
    end
  end
end
