class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :ensure_authentication

  def select2_fix( ids_list )
    clean_ids_list = ids_list.gsub("|,","").gsub("|","")
    result = clean_ids_list.split(",")
  end

  def ensure_authentication
    unless current_user
      redirect_to login_path, notice: "Faça o login para entrar no sistema, por favor."
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session.delete(:user_id)
    nil
  end
end
