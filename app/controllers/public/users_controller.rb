class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_user_search, only: [:index, :search]

  def index
    @users = User.page(params[:page]).per(8)
  end

  def show
    @user = User.find(params[:id])
    @new_tasks = @user.tasks.count_new
    @processing_tasks = @user.tasks.count_processing
    @completed_tasks = @user.tasks.count_completed
    @pending_tasks = @user.tasks.count_pending
    @task_chart = {
      '未着手' => @new_tasks,
      '処理中' => @processing_tasks,
      '完了済' => @completed_tasks,
      '保留中' => @pending_tasks,
    }
    @today_study_time = @user.learnings.today_study_time
    @yesterday_study_time = @user.learnings.yesterday_study_time
    @week_study_time = @user.learnings.week_study_time
    @month_study_time = @user.learnings.month_study_time
    @learning_chart = {
      '今日' => @today_study_time,
      '昨日' => @yesterday_study_time,
      '過去一週間' => @week_study_time,
      '過去1ヶ月' => @month_study_time,
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

  def set_user_search
    @search = User.ransack(params[:q])
    @user_search = @search.result.page(params[:page]).per(8)
  end
end
