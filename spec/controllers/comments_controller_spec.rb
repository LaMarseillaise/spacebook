require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  let(:user_post) { FactoryGirl.create(:post, author: user) }
  let(:comment) { FactoryGirl.create(:comment, author: user) }

  let(:valid_attrs) { FactoryGirl.attributes_for(:comment, commentable_type: "Post", commentable_id: user_post.id) }
  let(:invalid_attrs) { FactoryGirl.attributes_for(:comment, commentable_type: "Post", commentable_id: user_post.id, content: "H"*257)}

  before(:each) { sign_in(:user, user) }

  describe 'POST #create' do
    context 'given valid attributes' do
      it 'should create the comment' do
        expect{post :create, comment: valid_attrs}.to change(user_post.comments, :count).by 1
      end

      it 'should redirect to the commentable' do
        post :create, comment: valid_attrs
        expect(response).to redirect_to post_path(user_post)
      end
    end

    context 'given invalid attributes' do
      before(:each) { request.env['HTTP_REFERER'] = user_path(user) }

      it 'should not create the comment' do
        expect{post :create, comment: invalid_attrs}.not_to change(user_post.comments, :count)
      end

      it 'should redirect back' do
        post :create, comment: invalid_attrs
        expect(response).to redirect_to user_path(user)
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) { request.env['HTTP_REFERER'] = user_path(user) }

    it 'should delete the comment' do
      comment
      expect{ delete :destroy, id: comment.id }.to change(Comment, :count).by(-1)
    end

    it 'should redirect back' do
      delete :destroy, id: comment.id
      expect(response).to redirect_to user_path(user)
    end
  end
end
