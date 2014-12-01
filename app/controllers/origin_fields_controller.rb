class OriginFieldsController < ApplicationController
  before_action :set_origin_field, only: [:show, :edit, :update, :destroy]

  # GET /origin_fields
  # GET /origin_fields.json
  def index
    @origin_fields = OriginField.all
  end

  # GET /origin_fields/1
  # GET /origin_fields/1.json
  def show
  end

  # GET /origin_fields/new
  def new
    @origin_field = OriginField.new
  end

  # GET /origin_fields/1/edit
  def edit
  end

  # POST /origin_fields
  # POST /origin_fields.json
  def create
    @origin_field = OriginField.new(origin_field_params)

    respond_to do |format|
      if @origin_field.save
        format.html { redirect_to @origin_field, notice: "#{OriginField.model_name.human.capitalize} criado com sucesso" }
        format.json { render :show, status: :created, location: @origin_field }
      else
        format.html { render :new }
        format.json { render json: @origin_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /origin_fields/1
  # PATCH/PUT /origin_fields/1.json
  def update
    respond_to do |format|
      if @origin_field.update(origin_field_params)
        format.html { redirect_to @origin_field, notice: "#{OriginField.model_name.human.capitalize} atualizado com sucesso"}
        format.json { render :show, status: :ok, location: @origin_field }
      else
        format.html { render :edit }
        format.json { render json: @origin_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /origin_fields/1
  # DELETE /origin_fields/1.json
  def destroy
    @origin_field.destroy
    respond_to do |format|
      format.html { redirect_to origin_fields_url, notice: "#{OriginField.model_name.human.capitalize} excluido com sucesso" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_origin_field
      @origin_field = OriginField.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def origin_field_params
      params.require(:origin_field).permit(:field_name, :origin_pic, :data_type_origin_field, :fmbase_format_type, :generic_data_type, :decimal_origin_field, :mask_origin_field, :position_origin_field, :width_origin_field, :is_key, :will_use, :has_signal, :room_1_notes, :cd5_variable_number, :cd5_output_order, :cd5_variable_name, :cd5_origin_format, :cd5_origin_format_desc, :cd5_format, :cd5_format_desc, :default_value, :room_2_notes, :origin_id)
    end
end
