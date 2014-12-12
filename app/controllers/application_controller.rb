class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :ensure_authentication

  def ensure_authentication
    if not session[:user_id]
      redirect_to login_path, :notice => "Você esqueceu de fazer o login!"
    else
      @current_user = current_user
    end
  end

  def current_user
    return unless session[:user_id]
    User.find(session[:user_id])
  end
end
