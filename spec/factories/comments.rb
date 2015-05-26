FactoryGirl.define do
  factory :comment do
    association :author
    association :commentable, factory: :post

    content Faker::Lorem.sentence
  end
end
