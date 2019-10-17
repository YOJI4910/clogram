class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:policy] # current_userが使用可に
  before_action :configure_permitted_parameters, if: :devise_controller?


  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :user_name, :phone_number, :sex])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :user_name, :self_intro, :phone_number, :sex, :web_site])
  end
end
