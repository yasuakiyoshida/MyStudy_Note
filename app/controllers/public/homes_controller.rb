class Public::HomesController < ApplicationController
  before_action :set_learning_search, only: [:common_learnings, :search]
  
  def top
    @learnings = Learning.where(is_public: 1).page(params[:page]).reverse_order.limit(5)
  end
  
  def common_learnings
    @learnings = Learning.where(is_public: 1).page(params[:page]).reverse_order.per(8)
    if params[:tag_name]
      @learnings = Learning.tagged_with("#{params[:tag_name]}").page(params[:page]).reverse_order.per(8)
    end
  end
  
  def search
  end
  
  private
  
  def set_learning_search
    @search = Learning.ransack(params[:q])
    @learning_search = @search.result.page(params[:page]).reverse_order.per(8)
  end
end