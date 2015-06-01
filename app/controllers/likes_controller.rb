class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(like_params)
    if @like.save
      flash[:success] = "#{like_params[:likable_type].capitalize} liked"
      redirect_to session.delete(:return_to)
    else
      flash[:error] = "An error occurred while liking"
      redirect_to session.delete(:return_to)
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    if @like.destroy
      flash[:success] = "#{@like.likable_type} unliked"
      redirect_to session.delete(:return_to)
    else
      flash[:error] = "An error occurred while unliking"
      redirect_to session.delete(:return_to)
    end
  end

  private

  def like_params
    params.require(:like).permit(:likable_type, :likable_id)
  end
end
