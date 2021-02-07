class Public::UsersController < ApplicationController
  include Searchable
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_user_search, only: [:index, :search]

  def index
    # @users = User.page(params[:page]).per(8)
    @users = User.index_page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @new_tasks = @user.tasks.where(progress_status: 0).count
    @processing_tasks = @user.tasks.where(progress_status: 1).count
    @completed_tasks = @user.tasks.where(progress_status: 2).count
    @pending_tasks = @user.tasks.where(progress_status: 3).count
    @task_chart = {
      '未着手' => @new_tasks,
      '処理中' => @processing_tasks,
      '完了済' => @completed_tasks,
      '保留中' => @pending_tasks,
    }
    @learning_chart = {
      '今日' => @user.learnings.today_study_time,
      '昨日' => @user.learnings.yesterday_study_time,
      '過去一週間' => @user.learnings.week_study_time,
      '過去1ヶ月' => @user.learnings.month_study_time,
    }
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: '登録情報を変更しました'
    else
      render :edit
    end
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
