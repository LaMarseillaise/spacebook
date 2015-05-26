FactoryGirl.define do
  factory :post do
    association :author
    content Faker::Hacker.say_something_smart
  end

end
