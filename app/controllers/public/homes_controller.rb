class Public::HomesController < ApplicationController
  before_action :set_learning_search, only: [:common_learnings, :search]

  def top
    @learnings = Learning.publish.reverse_order.limit(5)
  end

  def common_learnings
    @learnings = Learning.publish.page(params[:page]).sorted(8)
    if params[:tag_name]
      @learnings = Learning.publish.tagged_with("#{params[:tag_name]}").page(params[:page]).sorted(8)
    end
  end

  private

  def set_learning_search
    @search = Learning.publish.ransack(params[:q])
    @learning_search = @search.result.page(params[:page]).sorted(8)
  end
end
