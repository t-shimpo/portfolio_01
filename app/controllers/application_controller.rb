class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :image])
  end

  def check_guest
    email = resource&.email || params[:user][:email].downcase
    if email == 'guestuser@example.com'
      redirect_to root_path, alert: 'ゲストユーザの編集または削除はできません。'
    end
  end

end
