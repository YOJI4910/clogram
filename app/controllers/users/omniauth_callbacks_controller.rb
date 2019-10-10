# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # facebookのページからコールバックしてくる
  def facebook
    callback_for(:facebook)
  end

  def failure
    redirect_to root_path
  end

  private

  # 共通callback処理
  def callback_for(provider)
    @user = User.find_for_omniauth(request.env["omniauth.auth"])
    # @userがDBに保存されていればtrue
    if @user.persisted?
      # ログイン、flashセット
      sign_in_and_redirect @user, event: :authentification
      if is_navigational_format?
        set_flash_message(:notice, :success, kind: "#{provider}".capitalize)
      end
    else
      # sessionにfacebookから受け取ったdata代入
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end
end
