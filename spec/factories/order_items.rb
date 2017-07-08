FactoryGirl.define do
  factory :order_item do
    # association :order, strategy: :build
    quantity 1
  end
end
