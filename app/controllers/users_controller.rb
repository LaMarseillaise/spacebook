class UsersController < ApplicationController
  def index
    @users = User.search_by_full_name(params[:query]).
      includes(profile: [:photo]).
      paginate(page: params[:page], per_page: 12)
  end

  def show
    @user = User.find(params[:id])
    @friends = @user.friends.includes(profile: :photo).shuffle[0..5]
    @posts = @user.posts.include_post_info.paginate(page: params[:page], per_page: 20)

    respond_to :html, :js
  end
end
