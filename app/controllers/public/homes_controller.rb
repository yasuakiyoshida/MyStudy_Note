class Public::HomesController < ApplicationController
  
  def top
    @learnings = Learning.where(is_public: 1).page(params[:page]).reverse_order.per(5)
    if params[:tag_name]
      @learnings = Learning.tagged_with("#{params[:tag_name]}").page(params[:page]).reverse_order.per(5)
    end
  end
end