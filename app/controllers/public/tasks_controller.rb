class Public::TasksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  
  def new
    @task = Task.new
  end
  
  def index
    @tasks = current_user.tasks
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def edit
  end
  
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    @task.save
    redirect_to tasks_path
  end
  
  def update
    @task.update(task_params)
    redirect_to request.referer
  end
  
  def destroy
    @task.destroy
    redirect_to request.referer
  end
  
  private
  
  def task_params
    params.require(:task).permit(:title, :detail, :priority_status, :due, :progress_status)
  end
  
  def ensure_correct_user
    @task = Task.find(params[:id])
    unless @task.user == current_user
      redirect_to root_path
    end
  end
end