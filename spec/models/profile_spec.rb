require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :photo }
    it { is_expected.to belong_to(:cover_photo).class_name('Photo') }
  end

  describe 'validations' do
    it { is_expected.to validate_length_of(:quotes).is_at_most(1000) }
    it { is_expected.to validate_length_of(:about).is_at_most(1000) }

    it { is_expected.to validate_length_of(:school).is_at_most(255) }
    it { is_expected.to validate_length_of(:hometown).is_at_most(255) }
    it { is_expected.to validate_length_of(:current_town).is_at_most(255) }
    it { is_expected.to validate_length_of(:phone_number).is_at_most(255) }

    it 'should validate the presence of the user' do
      FactoryGirl.create(:profile)
      should validate_presence_of(:user)
    end
  end
end
