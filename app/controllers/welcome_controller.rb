class WelcomeController < ApplicationController
  def index
    @filter = params[:status] || 'origin'
    if @filter == "origin"
      @entity_status  = Origin.select( :id ).select(:status).select( :file_name ).where( :status => Constants::STATUS[:SALA1]).order( :id => :desc ).to_a,
        Origin.select( :id ).select( :status).select( :file_name ).where( :status => Constants::STATUS[:SALA2]).order( :id => :desc ).to_a,
        Origin.select( :id ).select(:status).select( :file_name ).where( :status => 'producao').order( :id => :desc ).to_a
    elsif  @filter == "campaign"
      @entity_status  = Campaign.select( :id ).select(:status).select( :name ).where( :status => Constants::STATUS[:SALA1]).order( :id => :desc ).to_a,
        Campaign.select( :id ).select( :status).select( :name ).where( :status => Constants::STATUS[:SALA2]).order( :id => :desc ).to_a,
        Campaign.select( :id ).select(:status).select( :name ).where( :status => 'producao').order( :id => :desc ).to_a
    elsif  @filter == "variable"
      @entity_status  = Variable.select( :id ).select(:status).select( :name ).where( :status => Constants::STATUS[:SALA1]).order( :id => :desc ).to_a,
        Variable.select( :id ).select( :status).select( :name ).where( :status => Constants::STATUS[:SALA2]).order( :id => :desc ).to_a,
        Variable.select( :id ).select(:status).select( :name ).where( :status => 'producao').order( :id => :desc ).to_a
    elsif  @filter == "table"
      @entity_status  = Table.select( :id ).select(:status).select( :name ).where( :status => Constants::STATUS[:SALA1]).order( :id => :desc ).to_a,
        Table.select( :id ).select( :status).select( :name ).where( :status => Constants::STATUS[:SALA2]).order( :id => :desc ).to_a,
        Table.select( :id ).select(:status).select( :name ).where( :status => 'producao').order( :id => :desc ).to_a
    elsif  @filter == "processid"
      @entity_status  = Processid.select( :id ).select(:status).select( :mnemonic ).where( :status => Constants::STATUS[:SALA1]).order( :id => :desc ).to_a,
        Processid.select( :id ).select( :status).select( :mnemonic ).where( :status => Constants::STATUS[:SALA2]).order( :id => :desc ).to_a,
        Processid.select( :id ).select(:status).select( :mnemonic ).where( :status => 'producao').order( :id => :desc ).to_a
    end

    # get the maximum size array
    @max_size = @entity_status[0].size
    @max_size = @entity_status[1].size if @entity_status[1].size > @max_size
    @max_size = @entity_status[2].size if @entity_status[2].size > @max_size
    #
  end
end
