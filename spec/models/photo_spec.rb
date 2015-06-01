require 'rails_helper'

RSpec.describe Photo, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:author).class_name('User') }

    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:likers).through(:likes) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }

    it { is_expected.to have_attached_file(:photo) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :author }

    # it { is_expected.to validate_attachment_content_type(:photo).
    #       allowing('').
    #       rejecting('') }

    it { is_expected.to validate_attachment_presence :photo }
    it { is_expected.to validate_attachment_size(:photo).in(0..2.megabytes) }
  end
end
