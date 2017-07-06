FactoryGirl.define do
  factory :category do
    cats = ['mobile development', 'photo', 'web design', 'web development']
    sequence(:name) { |n| "#{cats[n % cats.length]}" }
  end
end
