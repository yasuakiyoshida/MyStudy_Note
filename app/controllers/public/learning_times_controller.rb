class Public::LearningTimesController < ApplicationController
  before_action :authenticate_user!

  def index
    @period = params[:period]
    @chart = current_user.learnings.learnings_period(@period)
  end
end
