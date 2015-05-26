FactoryGirl.define do
  factory :user, aliases: [:author, :liker] do
    first_name "John"
    last_name "Doe"
    sequence(:email) { |i| "John#{i}@example.com" }
    password "password"
    gender "Male"
    birthday Date.today - 21.years
  end
end
