
class WelcomeController < ActionController::Base
  def index
    if session[:user_id]
      redirect_to origins_path
    else
      render layout: false
    end
  end
end
