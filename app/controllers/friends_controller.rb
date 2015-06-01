class FriendsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @friends = @user.friends.includes(profile: :photo).paginate(:page => params[:page], :per_page => 12)
    respond_to :html, :js
  end

  def friend_requests
    @users = current_user.friend_requests.includes(profile: :photo).paginate(:page => params[:page], :per_page => 12)
  end

  def create
    @target = User.find(params[:id])
    @friend_request = current_user.initiated_friendings.build(friend_id: @target.id)

    respond_to do |format|
      if current_user != @target && @friend_request.save!
        format.html { redirect_to session.delete(:return_to), notice: "Friend request sent" }
        format.js { render :create, status: :created }
      else
        format.html { redirect_to session.delete(:return_to), notice: "Something went wrong with your friend request!" }
        format.js { render json: @friend_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @target = User.find(params[:id])
    friendings = Friending.where(friend_id: [@target.id, current_user.id],
                               friender_id: [@target.id, current_user.id])

    respond_to do |format|
      if friendings.destroy_all
        format.html { redirect_to session.delete(:return_to), notice: "User unfriended" }
        format.js
      end
    end
  end
end
