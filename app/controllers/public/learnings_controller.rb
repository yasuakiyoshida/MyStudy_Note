class Public::LearningsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :set_sidebar_base_data, only: [:new, :index, :show, :edit]

  def new
    @learning = Learning.new
  end

  def index
    @learnings = current_user.learnings.page(params[:page]).reverse_order.per(8)
  end

  def show
    @learning = Learning.find(params[:id])
    @user = @learning.user
    @learning_comment = LearningComment.new
    @learning_comments = @learning.learning_comments.page(params[:page]).per(5)
  end

  def edit
  end

  def create
    @learning = Learning.new(learning_params)
    @learning.user_id = current_user.id
    @learning.save
    redirect_to learning_path(@learning)
  end

  def update
    @learning.update(learning_params)
    redirect_to learning_path(@learning)
  end

  def destroy
    @learning.destroy
    redirect_to learnings_path
  end

  private

  def learning_params
    params.require(:learning).permit(:title, :image, :detail, :date, :time, :is_public)
  end

  def ensure_correct_user
    @learning = Learning.find(params[:id])
    unless @learning.user == current_user
      redirect_to learning_path(@learning)
    end
  end
end