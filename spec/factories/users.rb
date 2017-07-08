FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password '11111111'

    factory :admin_user do
      admin true
    end
  end
end
