class Public::TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:show, :update, :destroy]
  before_action :set_task_search, only: [:index, :search]
  before_action :set_new_task, only: [:index, :search]

  def index
    @tasks = current_user.tasks.page(params[:page]).order("due").per(10)
    if params[:tag_name]
      @tasks = current_user.tasks.tagged_with("#{params[:tag_name]}").page(params[:page]).order("due").per(10)
    end
  end

  def show
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      redirect_to task_path(@task), notice: 'ToDoリストを作成しました'
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task), notice: 'ToDoリストを更新しました'
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'ToDoリストを削除しました'
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
    @search = current_user.tasks.ransack(params[:q])
    @task_search = @search.result.page(params[:page]).order("due").per(10)
  end
end
