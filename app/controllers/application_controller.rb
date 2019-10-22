class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:policy] # current_userが使用可に
  before_action :configure_permitted_parameters, if: :devise_controller?
  # 検索フォームの設置
  before_action :set_search, except: [:login]

  private
    # 検索フォームの表示。結果の描画はigpost_controllerで行う
    def set_search
      @q = User.ransack(params[:q])
      @user_results = @q.result(distinct: true)
    end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :user_name, :phone_number, :sex])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :user_name, :self_intro, :phone_number, :sex, :web_site])
  end
end
