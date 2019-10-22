class Igpost < ApplicationRecord
  belongs_to :user
  has_many :favorites

  has_many :comments

  # 通知モデルの関連付け
  has_many :notifications, dependent: :destroy

  mount_uploader :image, ImageUploader

  # user(主にcurrent_userを想定)がフォローしていればtrue
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # コメント通知メソッド(アクセプターは@igpostを想定)
  def create_notification_comment!(current_user, comment_id)
    # 投稿者に対して通知を送る
    notification = current_user.active_notifications.new(
      igpost_id: self.id, # 実際は必要ないが一応保存
      comment_id: comment_id,
      visited_id: self.user_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true # 破壊的変更（多分）
    end
    notification.save if notification.valid?
  end

  # 投稿画像がfavされた時の通知メソッド
  def create_notification_fav!(current_user)
    # すでにfavされているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and igpost_id = ? and action = ? ", current_user.id, self.user_id, self.id, 'fav'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        igpost_id: self.id,
        visited_id: self.user_id,
        action: 'fav'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
end
