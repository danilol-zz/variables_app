class VariablesController < ApplicationController
  before_action :set_variable, only: [:edit, :update, :destroy]
  before_filter :ensure_authentication

  # GET /variables/new
  def new
    @origin_fields = OriginField.order(:field_name)
    @variable = Variable.new
  end

  # GET /variables/1/edit
  def edit
    @origin_fields = OriginField.order(:field_name)
  end

  # POST /variables
  # POST /variables.json
  def create
    @variable = Variable.new(variable_params)

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

  # PATCH/PUT /variables/1
  # PATCH/PUT /variables/1.json
  def update
    @variable.set_origin_fields(params[:variable][:origin_fields_list])

    respond_to do |format|
      if @variable.update(variable_params)
        format.html { redirect_to root_path({ status: "variable", notice: "#{Variable.model_name.human.capitalize} atualizada com sucesso" }) }
        format.json { render :show, status: :ok, location: @variable }
      else
        format.html { render :edit }
        format.json { render json: @variable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variables/1
  # DELETE /variables/1.json
  def destroy
    @variable.destroy
    respond_to do |format|
      format.html { redirect_to variables_url, notice: "#{Variable.model_name.human.capitalize} excluida com sucesso" }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_variable
    @variable = Variable.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
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
