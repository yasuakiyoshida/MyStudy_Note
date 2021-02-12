class Public::TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:show, :update, :destroy]
  before_action :set_task_search, only: [:index, :search, :destroy]
  before_action :set_new_task, only: [:index, :search]
  before_action :set_task_index, only: [:index, :destroy]

  def index
  end

  def show
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to task_path(@task), turbolinks: "advance", notice: 'ToDoリストを作成しました'
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task), turbolinks: "advance", notice: 'ToDoリストを更新しました'
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = 'ToDoリストを削除しました'
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :detail, :priority_status, :due, :progress_status, :tag_list)
  end

  def set_new_task
    @task = Task.new
  end

  def ensure_correct_user
    @task = Task.find(params[:id])
    unless @task.user == current_user
      redirect_to root_path
    end
  end

  def set_task_search
    @search = current_user.tasks.includes(:tags).ransack(params[:q])
    @task_search = @search.result.page(params[:page]).sorted(10)
  end

  def set_task_index
    @tasks = current_user.tasks.includes(:tags).page(params[:page]).sorted(10)
    if params[:tag_name]
      @tasks = current_user.tasks.includes(:tags).tagged_with("#{params[:tag_name]}").page(params[:page]).sorted(10)
    end
  end
end
