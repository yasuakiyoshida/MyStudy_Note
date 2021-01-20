class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_learning

  def create
    @favorite = current_user.favorites.new(learning_id: @learning.id)
    @favorite.save
  end

  def destroy
    @favorite = current_user.favorites.find_by(learning_id: @learning.id)
    @favorite.destroy
  end

  private

  def set_learning
    @learning = Learning.find(params[:learning_id])
  end
end
