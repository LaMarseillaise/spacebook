require 'rails_helper'

RSpec.describe FriendsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:nonfriend) { FactoryGirl.create(:user) }

  let(:friend) do
    f = FactoryGirl.create(:user)
    user.friended_users << f
    f.friended_users << user
    f
  end

  let(:requester) do
    r = FactoryGirl.create(:user)
    r.friended_users << user
    r
  end

  let(:receiver) do
    r = FactoryGirl.create(:user)
    user.friended_users << r
    r
  end

  before(:each) do
    sign_in(:user, user)
    request.env['HTTP_REFERER'] = profile_url(user)
  end

  describe 'GET #index' do
    before(:each) do
      friend; requester
      get :index, user_id: user.id
    end

    it 'gathers the user\'s friends' do
      expect(assigns(:friends)).to include friend
      expect(assigns(:friends)).not_to include requester
    end

    it 'renders the index page' do
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    it 'initiates a friend request' do
      nonfriend
      expect{post :create, id: nonfriend.id}.to change(user.friended_users, :count).by 1
    end

    it 'redirects back' do
      post :create, id: nonfriend.id
      expect(response).to redirect_to :back
    end
  end

  describe 'DELETE #destroy' do
    it 'cancels an outstanding request' do
      requester
      expect{delete :destroy, id: requester.id}.to change(user.users_friended_by, :count).by -1
    end

    it 'deletes an initiated friending' do
      receiver
      expect{delete :destroy, id: receiver.id}.to change(user.friended_users, :count).by -1
    end

    it 'deletes both sides of a friendship' do
      friend
      delete :destroy, id: friend.id
      user.reload; friend.reload
      expect(user.friends).not_to include(friend)
      expect(friend.friends).not_to include(friend)
    end

    it 'redirects back' do
      delete :destroy, id: friend.id
      expect(response).to redirect_to :back
    end
  end

  describe 'GET #friend_requests' do
    before(:each) { requester; get :friend_requests }

    it 'renders the friend request page' do
      expect(response).to render_template :friend_requests
    end

    it 'displays the user\'s friend requests' do
      expect(assigns(:users)).to include requester
    end
  end
end
