require 'rails_helper'

RSpec.describe Friending, type: :model do
  context 'associations' do
    it { is_expected.to belong_to :friend_initiator }
    it { is_expected.to belong_to :friend_recipient }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :friend_initiator }
    it { is_expected.to validate_presence_of :friend_recipient }

    it "should validate the uniqueness of the friending" do
      FactoryGirl.create :friending
      expect(subject).to validate_uniqueness_of(:friend_id).scoped_to(:friender_id)
    end
  end
end
