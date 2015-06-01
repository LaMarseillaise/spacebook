require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  let(:user_post) { FactoryGirl.create(:post, author: user) }
  let(:comment) { FactoryGirl.create(:comment, author: user) }

  let(:valid_attrs) { FactoryGirl.attributes_for(:comment, commentable_type: "Post", commentable_id: user_post.id) }
  let(:invalid_attrs) { FactoryGirl.attributes_for(:comment, commentable_type: "Post", commentable_id: user_post.id, content: "H"*257)}

  before(:each) do
    sign_in(:user, user)
    request.env['HTTP_REFERER'] = user_url(user)
  end

  describe 'POST #create' do
    context 'given valid attributes' do
      it 'creates the comment' do
        expect{post :create, comment: valid_attrs}.to change(user_post.comments, :count).by 1
      end

      it 'redirects back' do
        post :create, comment: valid_attrs
        expect(response).to redirect_to :back
      end
    end

    context 'given invalid attributes' do
      it 'does not create the comment' do
        expect{post :create, comment: invalid_attrs}.not_to change(user_post.comments, :count)
      end

      it 'redirects back' do
        post :create, comment: invalid_attrs
        expect(response).to redirect_to :back
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the comment' do
      comment
      expect{ delete :destroy, id: comment.id }.to change(Comment, :count).by(-1)
    end

    it 'redirects back' do
      delete :destroy, id: comment.id
      expect(response).to redirect_to :back
    end
  end
end
