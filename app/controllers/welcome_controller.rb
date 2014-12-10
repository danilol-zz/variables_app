class WelcomeController < ApplicationController
  def index
    if params[:status] == "origem" || params[:status].nil?
      @draft       = Origin.draft.order( :id => :desc )
      @development = Origin.development.order( :id => :desc )
      @done        = Origin.done.order( :id => :desc )
      @status_id = "OR"
    elsif params[:status] == "campanha"
      @draft       = Campaign.draft.order( :id => :desc )
      @development = Campaign.development.order( :id => :desc )
      @done        = Campaign.done.order( :id => :desc )
      @status_id = "CA"
    elsif params[:status] == "variavel"
      @draft       = Variable.draft.order( :id => :desc )
      @development = Variable.development.order( :id => :desc )
      @done        = Variable.done.order( :id => :desc )
      @status_id = "VA"
    end
  end
end
