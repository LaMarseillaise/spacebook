require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { FactoryGirl.create(:user) }

  let(:random_post) { FactoryGirl.create(:post) }

  context 'associations' do
    it { is_expected.to belong_to(:author).class_name('User') }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:likers).through(:likes) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(255) }
  end

  context 'scopes' do
    describe 'friends_posts' do
      subject { Post.friends_posts(user) }
      let!(:friend_post) do
        p = FactoryGirl.create(:post)
        user.friended_users << p.author
        user.users_friended_by << p.author
        p
      end

      it { is_expected.to include(friend_post) }
      it { is_expected.not_to include(random_post) }
    end

    describe 'posted_since' do
      subject { Post.posted_since(7.days.ago) }
      let(:recent_post) { FactoryGirl.create(:post, created_at: Time.now - 1.days) }
      let(:older_post)  { FactoryGirl.create(:post, created_at: Time.now - 9.days) }

      it { is_expected.to include(recent_post) }
      it { is_expected.not_to include(older_post) }
    end

    describe 'popular_posts' do
      subject { Post.popular_posts }

      let(:well_liked_post) do
        p = FactoryGirl.create(:post)
        3.times { p.likers << FactoryGirl.create(:user) }
        p
      end

      it { is_expected.to include(well_liked_post) }
      it { is_expected.not_to include(random_post) }
    end

    describe 'recently_popular' do
      subject { Post }

      before(:each) do
        allow(Post).to receive(:friends_posts).and_return(Post)
        allow(Post).to receive(:posted_since).and_return(Post)
        allow(Post).to receive(:popular_posts).and_return(Post)
      end

      after(:each){ Post.recently_popular(user, 7.days) }

      it { is_expected.to receive(:friends_posts) }
      it { is_expected.to receive(:posted_since) }
      it { is_expected.to receive(:popular_posts) }
    end
  end
end
