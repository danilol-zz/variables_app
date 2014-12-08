class WelcomeController < ApplicationController
  def index
    #redirect_to origins_path if session[:user_id]
    #unless session[:user_id]
    #  redirect_to login_path
    if params[:status] == "origem"
      @status = Origin.all.order( :id => :desc )
      @status_id = "OR"
    elsif params[:status] == "campanha"
      @status = Campaign.all.order( :id => :desc )
      @status_id = "CA"
    else
      @status = Variable.all.order( :id => :desc )
      @status_id = "VA"
    end
  end
end
