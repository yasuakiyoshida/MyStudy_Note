class Public::LearningCommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @learning = Learning.find(params[:learning_id])
    @learning_comment = current_user.learning_comments.new(learning_comment_params)
    @learning_comment.learning_id = @learning.id
    @learning_comment.save
    redirect_to learning_path(@learning)
  end
  
  def destroy
    LearningComment.find_by(id: params[:id], learning_id: params[:learning_id]).destroy
    redirect_to learning_path(params[:learning_id])
  end
  
  private

  def learning_comment_params
    params.require(:learning_comment).permit(:comment)
  end
end