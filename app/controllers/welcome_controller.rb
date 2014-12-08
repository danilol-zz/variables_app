class WelcomeController < ApplicationController
  def index
    if params[:status] == "origem" || params[:status].nil?
      @status = Origin.all.order( :id => :desc )
      @status_id = "OR"
    elsif params[:status] == "campanha"
      @status = Campaign.all.order( :id => :desc )
      @status_id = "CA"
    elsif params[:status] == "variavel"
      @status = Variable.all.order( :id => :desc )
      @status_id = "VA"
    end
  end
end
