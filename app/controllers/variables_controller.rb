class VariablesController < ApplicationController
  before_action :set_variable, only: [:edit, :update]
  before_filter :ensure_authentication

  def new
    @origin_fields = OriginField.joins(:origin).order('origins.file_name, field_name')
    @variable = Variable.new
  end

  def edit
    @origin_fields = OriginField.joins(:origin).order('origins.file_name, field_name')
  end

  def create
    @variable = Variable.new(variable_params.merge(status: Constants::STATUS[:SALA1]))

    @variable.set_origin_fields(params[:variable][:origin_fields_list], current_user.id)

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
    @variable.origin_fields.delete_all

    status = params[:update_status] ? { status: params[:update_status] } : {}

    @variable.set_origin_fields(params[:variable][:origin_fields_list])

    respond_to do |format|
      if @variable.update(variable_params.merge(status))
        format.html { redirect_to root_path({ status: "variable", notice: "#{Variable.model_name.human.capitalize} atualizada com sucesso" }) }
        format.json { render :show, status: :ok, location: @variable }
      else
        format.html { render :edit }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_variable
    @variable = Variable.find(params[:id])
  end

  def variable_params
    params.require(:variable).permit(
      :name,
      :sas_variable_def,
      :sas_variable_domain,
      :created_in_sprint,
      :updated_in_sprint,
      :sas_data_model_status,
      :drs_bi_diagram_name,
      :drs_variable_status,
      :room_1_notes,
      :physical_model_name_field,
      :width_variable,
      :decimal_variable,
      :default_value,
      :room_2_notes
    ).merge(current_user_id: current_user.id)
  end
end
