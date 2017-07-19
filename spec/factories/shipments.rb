FactoryGirl.define do
  factory :shipment do
    sequence(:method) { |n| "Delivery method ##{n}" }
    sequence(:days_min) { |n| n * 1 }
    sequence(:days_max) { |n| n * 6 }
    price 5.0
  end
end
