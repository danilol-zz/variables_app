class WelcomeController < ApplicationController
  def index
    redirect_to origins_path if session[:user_id]
  end
end
