class Public::UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
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