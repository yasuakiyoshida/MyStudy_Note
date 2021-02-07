module Searchable
  extend ActiveSupport::Concern

  private

  def set_user_search
    @search = User.ransack(params[:q])
    @user_search = @search.result.page(params[:page]).per(8)
  end
end
