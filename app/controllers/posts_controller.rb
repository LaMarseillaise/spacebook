class PostsController < ApplicationController
  skip_before_action :save_return_address, only: [:show]

  def index
    @posts = Post.friends_posts(current_user).order(created_at: :desc).include_post_info
              .paginate(page: params[:page], :per_page => 16)
    @popular_week = Post.recently_popular(current_user, 7.days)
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to session.delete(:return_to), notice: "Status updated" }
        format.js { render :create, status: :created, location: @post }
      else
        format.html { redirect_to session.delete(:return_to), notice: "Something went wrong with your post" }
        format.js { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])

    @post.destroy

    respond_to do |format|
      format.html { redirect_to session.delete(:return_to), notice: "Post deleted" }
      format.js { render :destroy, status: 200 }
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
