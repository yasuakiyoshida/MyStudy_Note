class Public::LearningsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :set_learning_search, only: [:index, :search]
  
  def new
    @learning = Learning.new
  end

  def index
    @learnings = current_user.learnings.page(params[:page]).reverse_order.per(8)
    if params[:tag_name]
      @learnings = current_user.learnings.tagged_with("#{params[:tag_name]}").page(params[:page]).reverse_order.per(8)
    end
  end

  def show
    @learning = Learning.find(params[:id])
    @learning_comment = LearningComment.new
    @learning_comments = @learning.learning_comments.page(params[:page]).per(5)
  end

  def edit
  end

  def create
    @learning = Learning.new(learning_params)
    @learning.user_id = current_user.id
    if @learning.save
      redirect_to learning_path(@learning), notice: "学習内容を記録しました"
    else
      render :new
    end
  end
  
  def update
    if @learning.update(learning_params)
      redirect_to learning_path(@learning), notice: "学習記録を更新しました"
    else
      render :edit
    end
  end
  
  def destroy
    @learning.destroy
    redirect_to learnings_path, notice: "学習記録を削除しました"
  end
  
  private

  def learning_params
    params.require(:learning).permit(:title, :image, :detail, :date, :time, :is_public, :tag_list)
  end

  def ensure_correct_user
    @learning = Learning.find(params[:id])
    unless @learning.user == current_user
      redirect_to learning_path(@learning)
    end
  end
  
  def set_learning_search
    @search = current_user.learnings.ransack(params[:q])
    @learning_search = @search.result.page(params[:page]).reverse_order.per(8)
  end
end