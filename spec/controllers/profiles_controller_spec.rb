require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:photo) { FactoryGirl.create(:photo, author: user) }

  before(:each) { sign_in(:user, user) }

  describe 'GET #show' do
    before(:each) { get :show, user_id: other_user.id }

    it 'renders the profile show page' do
      expect(response).to render_template :show
    end

    it 'finds a user\'s profile' do
      expect(assigns(:profile)).to eq(other_user.profile)
    end
  end

  describe 'GET #edit' do
    before(:each) { get :edit }

    it 'renders the profile edit page' do
      expect(response).to render_template :edit
    end

    it 'finds the current user\'s profile' do
      expect(assigns(:profile)).to eq(user.profile)
    end
  end

  describe 'PATCH #update' do
    context 'given valid attributes' do
      before(:each) do
        patch :update, profile: FactoryGirl.attributes_for(:profile, school: 'Hogwarts')
        user.profile.reload
      end

      it 'updates the profile' do
        expect(user.profile.school).to eq('Hogwarts')
      end

      it 'redirects to the profile show page' do
        expect(response).to redirect_to profile_path(user)
      end
    end

    context 'given invalid attributes' do
      before(:each) do
        patch :update, profile: FactoryGirl.attributes_for(:profile, school: 'H' * 257)
        user.profile.reload
      end

      it 'does not update the profile' do
        expect(user.profile.school).not_to eq('H'*257)
        expect(user.profile.school).to eq(nil)
      end

      it 're-renders the edit profile page' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'PATCH #update_photo' do
    context 'given a valid photo' do
      before(:each) do
        patch :update_photo, photo_id: photo.id
        user.profile.reload
      end

      it 'updates the profile_photo' do
        expect(user.profile_photo).to eq(photo)
      end

      it 'redirects to the photo show page' do
        expect(response).to redirect_to photo_path(photo)
      end
    end
  end

  describe 'PATCH #update_cover' do
    context 'given a valid photo' do
      before(:each) do
        patch :update_cover, photo_id: photo.id
        user.profile.reload
      end

      it 'updates the profile_photo' do
        expect(user.cover_photo).to eq(photo)
      end

      it 'redirects to the photo show page' do
        expect(response).to redirect_to photo_path(photo)
      end
    end
  end
end
