class Public::LearningTimesController < ApplicationController
  
  def index
    @user = User.find(params[:user_id])
    @period = params[:period]
    @chart = @user.learnings.learnings_period(@period)
  end
end