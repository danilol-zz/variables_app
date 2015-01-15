class TablesController < ApplicationController
  before_action :set_table, only: [:edit, :update]
  before_action :load_variables
  before_action :set_query_param, only: [:search]
  before_filter :ensure_authentication

  def variables_search
    result = []
    y = {}
    if params[:id].present?
      Table.find(params[:id]).variables.each { |r| y[:id] = r.id; y[:text] = r.name; result << y; y = {} }
    else
      Variable.all.each { |r| y[:id] = r.id; y[:text] = r.name; result << y; y = {} }
    end
    render json: result
  end

  def index
    @tables = Table.all.paginate(page: params[:page], per_page: 10)
  end

  def search
    @tables = Table.where(@text_param).where(@status_param).paginate(page: params[:page], per_page: 10).to_a

    render :index
  end

  def new
    @table = Table.new
  end

  def edit
  end

  def create
    @table = Table.new(table_params
      .merge(status: Constants::STATUS[:SALA1])
      .merge("variable_ids" => select2_fix(params[:variable_ids][0]) )
    )
    respond_to do |format|
      if @table.save
        format.html { redirect_to root_path({ status: "table", notice: "#{Table.model_name.human.capitalize} criada com sucesso" }) }
        format.json { render :show, status: :created, location: @table }
      else
        format.html { render :new }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    status = params[:update_status] ? { status: params[:update_status] } : {}
    respond_to do |format|
      if @table.update(table_params.merge(status).
        merge("variable_ids" => select2_fix(params[:variable_ids][0]) ) )
        format.html { redirect_to root_path({ status: 'table', notice: "#{Table.model_name.human.capitalize} atualizada com sucesso" }) }
        format.json { render :show, status: :ok, location: @table }
      else
        format.html { render :edit }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def load_variables
    @variables = Variable.order(:name)
  end

  def set_table
    @table = Table.find(params[:id])
  end

  def set_query_param
    @text_param   = Table.arel_table[:logic_table_name].matches("%#{params[:text_param]}%").to_sql
    @status_param = Table.arel_table[:status].matches("%#{params[:status_param]}%").to_sql
  end

  def table_params
    params.require(:table).permit(
      :logic_table_name,
      :table_type,
      :name,
      :table_key,
      :initial_volume,
      :growth_estimation,
      :created_in_sprint,
      :updated_in_sprint,
      :room_1_notes,
      :final_physical_table_name,
      :mirror_physical_table_name,
      :final_table_number,
      :mirror_table_number,
      :mnemonic,
      :routine_number,
      :master_base,
      :hive_table,
      :big_data_routine_name,
      :output_routine_name,
      :ziptrans_routine_name,
      :mirror_data_stage_routine_name,
      :final_data_stage_routine_name,
      :key_fields_hive_script,
      :room_2_notes,
      :status
    ).merge(current_user_id: current_user.id)
  end
end

