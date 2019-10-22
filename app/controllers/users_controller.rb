class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @my_pics = @user.igposts.order(id: "DESC")
    @fav_pics = @user.favorite_igposts.order(id: "DESC")
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to new_user_session_url, notice: "退会しました。"
  end
end
