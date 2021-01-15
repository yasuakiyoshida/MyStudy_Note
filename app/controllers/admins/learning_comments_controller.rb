class Admins::LearningCommentsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate_admin!
  
  def destroy
    LearningComment.find_by(id: params[:id], learning_id: params[:learning_id]).destroy
    redirect_to admins_learning_path(params[:learning_id])
  end
end