require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  let(:comment) { FactoryGirl.create(:comment, author: user) }
  let(:like) { FactoryGirl.create(:like, liker: user) }

  before(:each) do
    sign_in(:user, user)
    request.env['HTTP_REFERER'] = root_url
  end

  describe 'POST #create' do
    it 'likes the comment' do
      expect do
        post :create, like: { likable_type: "Comment", likable_id: comment.id }
      end.to change(comment.likes, :count).by 1
    end

    it 'redirects back' do
      post :create, like: { likable_type: "Comment", likable_id: comment.id }
      expect(response).to redirect_to :back
    end
  end

  describe 'DELETE #destroy' do
    it 'unlikes the comment' do
      like
      expect{ delete :destroy, id: like.id }.to change(Like, :count).by(-1)
    end

    it 'redirects back' do
      delete :destroy, id: like.id
      expect(response).to redirect_to :back
    end
  end
end
