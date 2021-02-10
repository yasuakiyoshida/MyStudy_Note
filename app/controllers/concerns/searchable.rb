module Searchable
  extend ActiveSupport::Concern

  private

  def set_user_search
    @search = User.ransack(params[:q])
    @user_search = @search.result.index_page(params[:page])
  end
end
