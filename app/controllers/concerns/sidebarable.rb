module Sidebarable
  extend ActiveSupport::Concern
  
  def set_sidebar
    @today_study_time = current_user.learnings.today_study_time
    @yesterday_study_time = current_user.learnings.yesterday_study_time
    @my_tasks = current_user.tasks.limit(5).order("due")
  end
  
end
