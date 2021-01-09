class Public::LearningTimesController < ApplicationController
  before_action :set_sidebar_base_data
  
  def index
    @period = params[:period]
    @chart = current_user.learnings.learnings_period(@period) 
  end
end