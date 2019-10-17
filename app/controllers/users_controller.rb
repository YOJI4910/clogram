class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def create
    # @user = User.new(user_params)
    
    # if @user.save
    #   # 登録と同時にログイン
    #   session[:user_id] = @user.id
    #   redirect_to root_url, notice:"ユーザー「#{@user.name}」を登録しました。"
    # else
    #   render :new
    # end
  end

  def show
    @user = User.find(params[:id])
    @my_pics = @user.igposts.order(id: "DESC")
    @fav_pics = @user.favorite_igposts.order(id: "DESC")
  end

  def edit
  end
end
