FactoryGirl.define do
  factory :like do
    association :likable, factory: :post
    association :liker
  end
end
