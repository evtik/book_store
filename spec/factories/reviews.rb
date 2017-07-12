FactoryGirl.define do
  factory :review do
    association :user, factory: :user_with_address, strategy: :build
    score 3
    title { Faker::Hipster.sentence(8) }
    body do
      'Some *italic text* with some **bold text**. ' +
        Faker::Hipster.paragraph(5, false, 3)
    end
    state 'approved'
  end
end
