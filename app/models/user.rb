class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:facebook]

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # コールバック時に呼び出されるメソッド
  def self.find_for_omniauth(auth)
    where(uid: auth.uid, provider: auth.provider).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
