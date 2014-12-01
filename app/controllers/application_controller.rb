class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def ensure_authentication
    if not session[:user_id]
      redirect_to root_url, :notice => "Você esqueceu de fazer o login!"
    else
      @current_user = current_user
    end
  end

  def current_user
    User.find(session[:user_id])
  end
end
