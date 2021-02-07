class Admins::LearningsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_learning, only: [:show, :edit, :update, :destroy]
  before_action :set_learning_search, only: [:index, :search]

  def index
    @learnings = Learning.page(params[:page]).sorted(8)
    if params[:tag_name]
      @learnings = Learning.tagged_with("#{params[:tag_name]}").page(params[:page]).sorted(8)
    end
  end

  def show
    @learning_comments = @learning.learning_comments.page(params[:page]).per(5)
    if params[:tag_name]
      @learnings = Learning.tagged_with("#{params[:tag_name]}").page(params[:page]).sorted(8)
    end
  end

  def edit
  end

  def update
    if @learning.update(learning_params)
      redirect_to admins_learning_path(@learning), notice: '学習記録を更新しました'
    else
      render :edit
    end
  end

  def destroy
    @learning.destroy
    redirect_to admins_learnings_path, notice: '学習記録を削除しました'
  end

  private

  def learning_params
    params.require(:learning).permit(:title, :image, :detail, :date, :time, :is_public, :tag_list)
  end

  def set_learning
    @learning = Learning.find(params[:id])
  end

  def set_learning_search
    @search = Learning.ransack(params[:q])
    @learning_search = @search.result.page(params[:page]).sorted(8)
  end
end
