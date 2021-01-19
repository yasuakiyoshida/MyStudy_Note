class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_user_search, only: [:index, :search]
  
  def index
    @users = User.page(params[:page]).per(5)
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to admins_user_path(@user), notice: 'ユーザー情報を変更しました'
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    redirect_to admins_users_path, notice: 'ユーザーを削除しました'
  end
  
  private
  
  def user_params
    params.require(:user).permit(:nickname, :image, :biography, :email)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def set_user_search
    @search = User.ransack(params[:q])
    @user_search = @search.result.page(params[:page]).per(5)
  end
end