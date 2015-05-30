FactoryGirl.define do
  factory :user, aliases: [:author, :liker] do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    sequence(:email) { |i| "John#{i}@example.com" }
    password "password"
    gender ["Female", "Male", "Other"].sample
    birthday Date.today - 21.years
  end
end
