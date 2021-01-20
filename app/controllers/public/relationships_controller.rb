class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:followings, :followers]

  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer, notice: "フォローしました"
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer, notice: "フォローを解除しました"
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
