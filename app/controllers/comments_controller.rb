class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to session.delete(:return_to) }
        format.js
      else
        format.html { redirect_to session.delete(:return_to), notice: "An error occurred" }
        format.js { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])

    if @comment.destroy
      respond_to do |format|
        format.html { redirect_to session.delete(:return_to), notice: "Comment deleted" }
        format.js
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id)
  end
end
