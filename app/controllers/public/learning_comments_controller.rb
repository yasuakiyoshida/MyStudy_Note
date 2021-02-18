class Public::LearningCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @learning = Learning.find(params[:learning_id])
    @learning_comment = current_user.learning_comments.new(learning_id: @learning.id, comment: learning_comment_params[:comment])
    @learning_comment.save
    redirect_to learning_path(@learning), notice: 'コメントしました'
  end

  def destroy
    LearningComment.find_by(id: params[:id], learning_id: params[:learning_id]).destroy
    redirect_to learning_path(params[:learning_id]), notice: 'コメントを削除しました'
  end

  private

  def learning_comment_params
    params.require(:learning_comment).permit(:comment)
  end
end
