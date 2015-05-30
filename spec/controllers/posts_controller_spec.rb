require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  let(:user_post) { FactoryGirl.create(:post, author: user) }

  let(:valid_attrs)   { FactoryGirl.attributes_for(:post) }
  let(:invalid_attrs) { FactoryGirl.attributes_for(:post, content: "H"*257) }

  before(:each) { sign_in(:user, user) }

  describe 'GET #index' do
    let(:friend) do
      f = FactoryGirl.create(:user)
      user.friended_users << f
      f.friended_users << user
      f
    end

    let!(:friend_post) { FactoryGirl.create(:post, author: friend) }
    let!(:random_post) { FactoryGirl.create(:post) }

    before(:each) { user_post; get :index }

    it 'renders the index page' do
      expect(response).to render_template :index
    end

    it 'shows only the user\'s friends\' posts' do
      expect(assigns(:posts)).to include(friend_post)
      expect(assigns(:posts)).to include(user_post)
      expect(assigns(:posts)).not_to include(random_post)
    end
  end

  describe 'POST #create' do
    context 'given valid attributes' do
      it 'creates a post' do
        expect{ post :create, post: valid_attrs }.to change(Post, :count).by(1)
      end

      it 'redirects to the user\'s show page' do
        post :create, post: valid_attrs
        expect(response).to redirect_to user_path(user)
      end
    end

    context 'given invalid attributes' do
      it 'does not create an invalid post' do
        expect{ post :create, post: invalid_attrs }.not_to change(Post, :count)
      end

      it 'redirect to the user\'s show page' do
        post :create, post: invalid_attrs
        expect(response).to redirect_to user_path(user)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the post' do
      user_post
      expect{ delete :destroy, id: user_post.id }.to change(Post, :count).by(-1)
    end

    it 'redirects to the user\'s show page' do
      delete :destroy, id: user_post.id
      expect(response).to redirect_to user_path(user)
    end
  end
end
