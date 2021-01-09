class Public::FavoritesController < ApplicationController
  
  def create
    learning = Learning.find(params[:learning_id])
    favorite = current_user.favorites.new(learning_id: learning.id)
    favorite.save
    redirect_to learning_path(learning)
  end
  
  def destroy
    learning = Learning.find(params[:learning_id])
    favorite = current_user.favorites.find_by(learning_id: learning.id)
    favorite.destroy
    redirect_to learning_path(learning)
  end
end