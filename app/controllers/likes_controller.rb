class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(like_params)
    @likable = @like.likable
    @like.save

    respond_to do |format|
      format.html { redirect_to session.delete(:return_to) }
      format.js
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @likable = @like.likable
    @like.destroy

    @likable.reload

    respond_to do |format|
      format.html { redirect_to session.delete(:return_to) }
      format.js
    end
  end

  private

  def like_params
    params.require(:like).permit(:likable_type, :likable_id)
  end
end
