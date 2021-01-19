class Public::LearningTimesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = User.find(params[:user_id])
    @period = params[:period]
    @chart = @user.learnings.learnings_period(@period)
  end
end