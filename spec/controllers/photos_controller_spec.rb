require 'rails_helper'


RSpec.describe PhotosController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:user_photo) { FactoryGirl.create(:photo, author: user) }

  let(:valid_attrs) { {photo: fixture_file_upload('user_silhouette.gif', 'image/gif')} }
  let(:invalid_attrs) { {photo: fixture_file_upload('test.txt', 'text/txt')} }

  before(:each) { sign_in(:user, user) }

  describe 'GET #index' do
    before(:each) { user_photo; get :index, user_id: user }

    it 'renders the index page' do
      expect(response).to render_template :index
    end

    it 'assigns the user' do
      expect(assigns(:user)).to eq user
    end

    it 'collects the user\'s photos' do
      expect(assigns(:photos)).to include user_photo
    end
  end

  describe 'GET #show' do
    before(:each) { get :show, id: user_photo.id }

    it 'renders the show page' do
      expect(response).to render_template :show
    end

    it 'assigns the photo' do
      expect(assigns(:photo)).to eq user_photo
    end
  end

  describe 'GET #new' do
    before(:each) { get :new }

    it 'renders the new photo page' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates the photo' do
        expect{post :create, photo: valid_attrs}.to change(Photo, :count).by 1
      end

      it 'redirects to the photo show page' do
        post :create, photo: valid_attrs
        expect(response).to redirect_to photo_path(assigns(:photo))
      end
    end

    context 'with invalid attributes' do
      it 'does not create the photo' do
        expect{post :create, photo: invalid_attrs}.not_to change(Photo, :count)
      end

      it 're-renders the new form' do
        post :create, photo: invalid_attrs
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the photo' do
      user_photo
      expect{ delete :destroy, id: user_photo.id }.to change(Photo, :count).by -1
    end

    it 'redirects to the user\'s photos index' do
      delete :destroy, id: user_photo.id
      expect(response).to redirect_to user_photos_path(user)
    end
  end
end
