class VariablesController < ApplicationController
  before_action :set_variable, only: [:edit, :update]
  before_action :load_origin_fields
  before_action :set_query_param, only: [:search]
  before_filter :ensure_authentication

  def name_search
    if params[:term].present?
      @variables = Variable.where( "variables.name like ?", "%#{params[:term]}%" )
    else
      @variables = Variable.all
    end
    render json: @variables
  end

  def origin_fields_search
    result = []
    y = {}
    if params[:id].present?
      Variable.find(params[:id]).origin_fields.each { |r| y[:id] = r.id; y[:text] = r.origin_file_field_name; result << y; y = {} }
    else
      OriginField.all.each { |r| y[:id] = r.id; y[:text] = r.field_name; result << y; y = {} }
    end
    render json: result
  end


  def index
    @variables = Variable.all.paginate(page: params[:page], per_page: 10)
  end

  def search
    @variables = Variable.where(@text_param).where(@status_param).paginate(page: params[:page], per_page: 10).to_a

    render :index
  end

  def new
    @variable = Variable.new
  end

  def edit
  end

  def create
    @variable = Variable.new(variable_params
      .merge(status: Constants::STATUS[:SALA1])
      .merge("origin_field_ids" => select2_fix(params[:origin_field_ids][0]))
    )
    #@variable.set_origin_fields(params[:variable][:origin_fields_list], current_user.id)
    #@variable.set_origin_fields(select2_fix(params[:origin_field_ids][0]), current_user.id)
    respond_to do |format|
      if @variable.save
        format.html { redirect_to root_path({ status: "variable", notice: "#{Variable.model_name.human.capitalize} criada com sucesso" } ) }
        format.json { render :show, status: :created, location: @variable }
      else
        format.html { render :new }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    status = params[:update_status] ? { status: params[:update_status] } : {}
    #if params[:variable][:origin_fields_list]
    #  @variable.origin_fields.delete_all
    #  @variable.set_origin_fields(params[:variable][:origin_fields_list])
    #end
    respond_to do |format|
      if @variable.update(variable_params.merge(status)
        .merge("origin_field_ids" => select2_fix(params[:origin_field_ids][0]) ) )
        format.html { redirect_to root_path({ status: "variable", notice: "#{Variable.model_name.human.capitalize} atualizada com sucesso" }) }
        format.json { render :show, status: :ok, location: @variable }
      else
        format.html { render :edit }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def load_origin_fields
    @origin_fields = OriginField.joins(:origin).order('origins.file_name, field_name')
  end

  def set_variable
    @variable = Variable.find(params[:id])
  end

  def set_query_param
    @text_param   = Variable.arel_table[:name].matches("%#{params[:text_param]}%").to_sql
    @status_param = Variable.arel_table[:status].matches("%#{params[:status_param]}%").to_sql
  end

  def variable_params
    params.require(:variable).permit(
      :name,
      :model_field_name,
      :data_type,
      :width,
      :decimal,
      :sas_variable_def,
      :sas_variable_rule_def,
      :sas_update_periodicity,
      :domain_type,
      :sas_variable_domain,
      :created_in_sprint,
      :updated_in_sprint,
      :sas_data_model_status,
      :drs_bi_diagram_name,
      :drs_variable_status,
      :room_1_notes,
      :variable_type,
      :default_value,
      :room_2_notes,
      :owner,
      :status
    ).merge(current_user_id: current_user.id)
  end
end
