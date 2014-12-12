class WelcomeController < ApplicationController
  def index
    @filter = params[:status] || 'origin'
    if @filter == "origin" #params[:status] == "origem" || params[:status].nil?
      #@draft       = Origin.draft
      #@development = Origin.development 
      #@done        = Origin.done 
      #@entity_status  = Origin.all.order( :id => :desc )
      @entity_status  = Origin.select( :id ).select(:status).select( :file_name ).where( :status => 'Rascunho').order( :id => :desc ).to_a, 
        Origin.select( :id ).select( :status).select( :file_name ).where( :status => 'Desenvolvimento').order( :id => :desc ).to_a, 
        Origin.select( :id ).select(:status).select( :file_name ).where( :status => 'Finalizado').order( :id => :desc ).to_a
    elsif  @filter == "campaign" #params[:status] == "campanha"
      #@draft       = Campaign.draft 
      #@development = Campaign.development 
      #@done        = Campaign.done
      #@entity_status      = Campaign.all.order( :id => :desc )
      @entity_status  = Campaign.select( :id ).select(:status).select( :name ).where( :status => 'Rascunho').order( :id => :desc ).to_a, 
        Campaign.select( :id ).select( :status).select( :name ).where( :status => 'Desenvolvimento').order( :id => :desc ).to_a, 
        Campaign.select( :id ).select(:status).select( :name ).where( :status => 'Finalizado').order( :id => :desc ).to_a      
    elsif  @filter == "variable" #params[:status] == "variavel"
      #@draft       = Variable.draft 
      #@development = Variable.development 
      #@done        = Variable.done 
      #@entity_status      = Variable.all.order( :id => :desc )
      @entity_status  = Variable.select( :id ).select(:status).select( :name ).where( :status => 'Rascunho').order( :id => :desc ).to_a, 
        Variable.select( :id ).select( :status).select( :name ).where( :status => 'Desenvolvimento').order( :id => :desc ).to_a, 
        Variable.select( :id ).select(:status).select( :name ).where( :status => 'Finalizado').order( :id => :desc ).to_a            
    elsif  @filter == "table" 
      @entity_status  = Table.select( :id ).select(:status).select( :name ).where( :status => 'Rascunho').order( :id => :desc ).to_a, 
        Table.select( :id ).select( :status).select( :name ).where( :status => 'Desenvolvimento').order( :id => :desc ).to_a, 
        Table.select( :id ).select(:status).select( :name ).where( :status => 'Finalizado').order( :id => :desc ).to_a
    elsif  @filter == "processid" 
      @entity_status  = Processid.select( :id ).select(:status).select( :name ).where( :status => 'Rascunho').order( :id => :desc ).to_a, 
        Processid.select( :id ).select( :status).select( :name ).where( :status => 'Desenvolvimento').order( :id => :desc ).to_a, 
        Processid.select( :id ).select(:status).select( :name ).where( :status => 'Finalizado').order( :id => :desc ).to_a
    end

    # get the maximum size array 
    @max_size = @entity_status[0].size
    @max_size = @entity_status[1].size if @entity_status[1].size > @max_size 
    @max_size = @entity_status[2].size if @entity_status[2].size > @max_size  
    #
  end
end
