require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){ FactoryGirl.create :user }

  context 'associations' do
    it { is_expected.to have_one :profile }
    it { is_expected.to have_one :cover_photo }

    it { is_expected.to have_many :posts }
    it { is_expected.to have_many :comments }
    it { is_expected.to have_many :photos }
    it { is_expected.to have_many :likes }
    it { is_expected.to have_many :initiated_friendings }
    it { is_expected.to have_many :friended_users }
    it { is_expected.to have_many :received_friendings }
    it { is_expected.to have_many :users_friended_by }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
    it { is_expected.to validate_presence_of :email }

    it 'should validate tag uniqueness of email' do
      FactoryGirl.create :user
      should validate_uniqueness_of :email
    end

    it { is_expected.to validate_length_of(:password).is_at_least(8) }
    it { is_expected.to allow_value(nil).for(:gender) }
    it { is_expected.to validate_inclusion_of(:gender).
          in_array(["Female", "Male", "Other"]) }
  end

  context 'instance methods' do
    describe '#name' do
      subject { user.name }
      it { is_expected.to eq(user.first_name + " " + user.last_name) }
    end

    describe 'friend methods' do
      let!(:friending_user) do
        u = FactoryGirl.create(:user)
        u.friended_users << user
        u
      end

      let!(:friended_user) do
        u = FactoryGirl.create(:user)
        u.users_friended_by << user
        u
      end

      let!(:friend) do
        u = FactoryGirl.create(:user)
        u.users_friended_by << user
        u.friended_users << user
        u
      end

      describe '#friend_requests' do
        subject { user.friend_requests }

        it { is_expected.not_to include friend }
        it { is_expected.to include friending_user }
        it { is_expected.not_to include friended_user }
      end

      describe 'friends' do
        subject { user.friends }

        it { is_expected.to include friend }
        it { is_expected.not_to include friending_user }
        it { is_expected.not_to include friended_user }
      end
    end
  end
end
