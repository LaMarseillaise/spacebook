require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:friend) do
    f = FactoryGirl.create(:user)
    user.friended_users << f
    f.friended_users << user
    f
  end

  let(:friend_post) { FactoryGirl.create(:post, author: friend) }

  before(:each) { sign_in(:user, user) }

  describe 'GET #show' do
    before(:each) do
      friend_post
      get :show, id: friend.id
    end

    it 'renders the show page' do
      expect(response).to render_template :show
    end

    it 'assigns an @user variable' do
      expect(assigns(:user)).to eq friend
    end

    it 'collects that user\'s posts' do
      expect(assigns(:posts)).to include friend_post
    end

    it 'collects that user\'s friends' do
      expect(assigns(:friends)).to include user
    end
  end
end
