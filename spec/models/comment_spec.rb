require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'associations' do
    it { is_expected.to belong_to :commentable }
    it { is_expected.to belong_to(:author).class_name('User') }

    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:likers).through(:likes) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :author }
    it { is_expected.to validate_presence_of :commentable }
    it { is_expected.to validate_presence_of :content }

    it { is_expected.to validate_inclusion_of(:commentable_type).
          in_array(["Post", "Photo"]) }

    it { is_expected.to validate_length_of(:content).is_at_most(140) }
  end
end
