class Public::TaskProgressesController < ApplicationController
  # このコントローラー必要か？
  def update
    @task = Task.find(params[:id])
    @task.update(task_params)
    redirect_to request.referer
  end
  
  private
  
  def task_params
    params.require(:task).permit(:title, :detail, :priority_status, :due, :progress_status)
  end
end
