class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def set_sidebar_base_data
    @my_today_study_time = current_user.learnings.today_study_time
    @my_yesterday_study_time = current_user.learnings.yesterday_study_time
    @my_tasks = current_user.tasks.limit(5).order("due")
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end
end