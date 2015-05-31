class UsersController < ApplicationController
  def friend_requests
    @users = current_user.friend_requests.includes(profile: :photo).paginate(:page => params[:page], :per_page => 12)
  end

  def show
    @user = User.find(params[:id])
    @friends = @user.friends.includes(profile: :photo).shuffle[0..5]
    @posts = @user.posts.include_post_info.paginate(:page => params[:page], :per_page => 20)

    respond_to :html, :js
  end
end
