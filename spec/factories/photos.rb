FactoryGirl.define do
  factory :photo do
    association :author

    photo File.open(Rails.root + 'app/assets/images/user_silhouette_generic.gif')
  end
end
