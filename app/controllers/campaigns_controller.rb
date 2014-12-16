class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_authentication

  # GET /campaigns
  # GET /campaigns.json
  def index
    @campaigns = Campaign.all
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
  end

  # GET /campaigns/new
  def new
    @variables = Variable.order(:name)
    @campaign = Campaign.new
  end

  # GET /campaigns/1/edit
  def edit
    @variables = Variable.order(:name)
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = Campaign.new(campaign_params)

    params[:campaign][:variable_list].each do |var|
      @campaign.variables << Variable.find(var.first)
    end

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to root_path({ status: 'campaign', notice: "#{Campaign.model_name.human.capitalize} criada com sucesso" }) }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update
    @campaign.variables.delete_all

    params[:campaign][:variable_list].each do |var|
      @campaign.variables << Variable.find(var.first)
    end

    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to root_path({ status: 'campaign', notice: "#{Campaign.model_name.human.capitalize} atualizada com sucesso" }) }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: "#{Campaign.model_name.human.capitalize} excluida com sucesso" }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def campaign_params
    params.require(:campaign).permit(:ident, :name, :priority, :created_in_sprint, :updated_in_sprint, :campaign_origin, :channel, :communication_channel, :product, :description, :criterion, :exists_in_legacy, :automatic_routine, :factory_criterion_status, :prioritized_variables_qty, :complied_variables_qty, :process_type, :crm_room_suggestion, :it_status, :notes, :variable_list)
  end
end
