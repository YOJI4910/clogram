class FavoritesController < ApplicationController
  def create
    favorite = current_user.favorites.build(igpost_id: params[:igpost_id])
    favorite.save!
    @fav_igpost = Igpost.find(params[:igpost_id])
    # fav通知
    @fav_igpost.create_notification_fav!(current_user)
    # Ajax favorites/create.js.erbでレンダリング
  end

  def destroy
    favorite = Favorite.find_by(igpost_id: params[:igpost_id], user_id: current_user.id)
    favorite.destroy
    @fav_igpost = Igpost.find(params[:igpost_id])
    # Ajax favorites/destroy.js.erbでレンダリング
  end
end
