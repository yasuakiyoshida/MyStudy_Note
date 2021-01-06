class Public::UsersController < ApplicationController
  # 後でコメントアウト解除
  # skip_before_action :authenticate_user!, only: [:show]
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_sidebar_base_data, only: [:index, :show, :edit]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @new_tasks = @user.tasks.where(progress_status: 0)
    @processing_tasks = @user.tasks.where(progress_status: 1)
    @completed_tasks = @user.tasks.where(progress_status: 2)
    @pending_tasks = @user.tasks.where(progress_status: 3)
    @today_study_time = @user.learnings.today_study_time
    @week_study_time = @user.learnings.week_study_time
    @month_study_time = @user.learnings.month_study_time
  end
  
  def edit
  end
  
  def update
    @user.update(user_params)
    redirect_to user_path(@user)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:nickname, :image, :biography, :email)
  end
  
  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end