class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:edit, :update]
  before_action :load_variables
  before_action :set_query_param, only: [:search]
  before_filter :ensure_authentication

  def variables_search
    result = []
    y = {}
    if params[:id].present?
      Campaign.find(params[:id]).variables.each { |r| y[:id] = r.id; y[:text] = r.name; result << y; y = {} }
    else
      Variable.all.each { |r| y[:id] = r.id; y[:text] = r.name; result << y; y = {} }
    end
    render json: result
  end

  def index
    params[:query] = {}
    @campaigns = Campaign.all.paginate(page: params[:page], per_page: 10)
  end

  def search
    @campaigns = Campaign.where(@name_query).where(@status_query).paginate(page: 1, per_page: 10).to_a

    render :index
  end

  def new
    @campaign = Campaign.new
  end

  def edit
  end

  def create
    @campaign = Campaign.new(campaign_params
      .merge(status: Constants::STATUS[:SALA1])
      .merge("variable_ids" => select2_fix(params[:variable_ids][0]) )
    )
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

  def update
    status = params[:update_status] ? { status: params[:update_status] } : {}
    respond_to do |format|
      if @campaign.update(campaign_params.merge(status).
        merge("variable_ids" => select2_fix(params[:variable_ids][0]) ) )
        format.html { redirect_to root_path({ status: 'campaign', notice: "#{Campaign.model_name.human.capitalize} atualizada com sucesso" }) }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def load_variables
    @variables = Variable.order(:name)
  end

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def set_query_param
    @name_query = @status_query = nil

    if params[:query]
      @name_query = Campaign.arel_table[:name].matches("%#{params[:query][:name]}%").to_sql
      @status_query    = Campaign.arel_table[:status].matches("%#{params[:query][:status]}%").to_sql
    end
  end

  def campaign_params
    params.require(:campaign).permit(
      :ident,
      :name,
      :priority,
      :created_in_sprint,
      :updated_in_sprint,
      :campaign_origin,
      :channel,
      :communication_channel,
      :product,
      :criterion,
      :description,
      :exists_in_legacy,
      :automatic_routine,
      :factory_criterion_status,
      :process_type,
      :crm_room_suggestion,
      :it_status,
      :notes,
      :owner,
      :status).merge(current_user_id: current_user.id)
  end
end
