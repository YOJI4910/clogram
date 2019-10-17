class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:facebook]

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :igposts, dependent: :destroy

  has_many :favorites
  has_many :favorite_igposts, through: :favorites, source: :igpost

  has_many :comments

  # ========================================================フォローしているユーザー視点
  # 中間テーブルと関係. 外部キーはfollowing_id
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: :following_id, dependent: :destroy
  # followerテーブルとの関係. ただしacitve_relationshipsテーブルのfollowerカラムを介して
  has_many :followings, through: :active_relationships, source: :follower
  # =====================================================================================

  # ======================================================フォローされているユーザー視点
  # 中間テーブルと関係. 外部キーはfollower_id
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: :follower_id, dependent: :destroy
  # followerテーブルとの関係. ただしacitve_relationshipsテーブルのfollowerカラムを介して
  has_many :followers, through: :passive_relationships, source: :following
  # ====================================================================================

  # 通知モデルの関連付け
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  # コールバック時に呼び出されるメソッド
  def self.find_for_omniauth(auth)
    where(uid: auth.uid, provider: auth.provider).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def follow(other_user)
    active_relationships.create(follower_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(follower_id: other_user.id).destroy
  end

  # レシーバーがcurrent_userがフォローしていたらtrue
  def following?(other_user)
    followings.include?(other_user)
  end

  # フォロー時の通知メソッド(アクセプターはfollowされるuser)
  def create_notification_follow!(current_user)
    # すでに同じ通知がないか確認（連打対策）
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, self.id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: self.id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
end
