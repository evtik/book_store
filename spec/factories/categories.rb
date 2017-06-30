FactoryGirl.define do
  factory :category, class: Category do
    name { Faker::Book.title }
  end
end
