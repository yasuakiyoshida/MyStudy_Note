class Public::LearningTimesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    @learnings = @user.learnings
    @period = params[:period]
    @chart = @learnings.learnings_period(@period)
  end
end
