FactoryGirl.define do
  factory :photo do
    association :author

    photo File.open(Rails.root + 'spec/fixtures/user_silhouette.gif')
  end
end
