class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @profile = @user.profile

    respond_to :html, :js
  end

  def edit
    @user = current_user
    @profile = current_user.profile
    respond_to :html, :js
  end

  def update
    @profile = current_user.profile

    if @profile.update_attributes(profile_params)
      flash[:success] = "Profile updated"
      redirect_to profile_path(current_user)
    else
      flash[:error] = "Something went wrong when saving your profile"
      render :edit
    end
  end

  def update_photo
    @photo = current_user.photos.find(params[:photo_id])
    current_user.profile_photo = @photo
    redirect_to session.delete(:return_to)
  end

  def update_cover
    @photo = current_user.photos.find(params[:photo_id])
    current_user.cover_photo = @photo
    redirect_to session.delete(:return_to)
  end

  private

  def profile_params
    params.require(:profile).permit(:school, :hometown, :current_town,
                                    :phone_number, :quotes, :about)
  end
end
