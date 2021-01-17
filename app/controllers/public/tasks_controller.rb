class Public::TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:show, :edit, :update, :destroy]
  before_action :set_task_search, only: [:index, :search]
  
  def new
    @task = Task.new
  end
  
  def index
    @tasks = current_user.tasks.page(params[:page]).order("due").per(10)
    if params[:tag_name]
      @tasks = current_user.tasks.tagged_with("#{params[:tag_name]}").page(params[:page]).order("due").per(10)
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      redirect_to task_path(@task)
    else
      render :new
    end
  end
  
  def update
    if @task.update(task_params)
      redirect_to task_path(@task)
    else
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    redirect_to tasks_path
  end
  
  private
  
  def task_params
    params.require(:task).permit(:title, :detail, :priority_status, :due, :progress_status, :tag_list)
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