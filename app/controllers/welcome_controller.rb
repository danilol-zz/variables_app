class WelcomeController < ApplicationController
  def index
    if params[:status] == "origem" || params[:status].nil?
      @status = Origin.all.order( :id => :desc )
    elsif params[:status] == "campanha"
      @status = Campaign.all.order( :id => :desc )
    elsif params[:status] == "variavel"
      @status = Variable.all.order( :id => :desc )
    elsif params[:status] == "tabela"
      @status = Table.all.order( :id => :desc )
    elsif params[:status] == "processo"
      @status = Processid.all.order( :id => :desc )
     end
  end
end
