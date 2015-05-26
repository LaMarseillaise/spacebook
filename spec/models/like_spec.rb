require 'rails_helper'

RSpec.describe Like, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:likable).counter_cache(true) }
    it { is_expected.to belong_to(:liker).class_name('User') }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :likable }
    it { is_expected.to validate_presence_of :liker }
    it { is_expected.to validate_inclusion_of(:likable_type).
          in_array(["Post", "Comment", "Photo"]) }

    it 'should validate the uniqueness of the like for a user' do
      FactoryGirl.create :like
      expect(subject).to validate_uniqueness_of(:liker).
        scoped_to([:likable_type, :likable_id])
    end
  end
end
