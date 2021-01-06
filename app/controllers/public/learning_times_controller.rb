class Public::LearningTimesController < ApplicationController
  
  def index
    @period = params[:period]
    @chart = current_user.learnings.learnings_period(@period) 
  end
end