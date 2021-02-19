class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    current_user.follow(params[:user_id])
  end

  def destroy
    current_user.unfollow(params[:user_id])
  end

  def followings
    @users = @user.followings.page(params[:page]).per(8)
  end

  def followers
    @users = @user.followers.page(params[:page]).per(8)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
