class OriginsController < ApplicationController
  before_action :set_origin, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_authentication

  def index
    @origins = Origin.all
  end

  def show
    @origin_field = OriginField.new
  end

  def new
    @origin = Origin.new
  end

  def edit
  end

  def create
    @origin = Origin.new(origin_params)

    respond_to do |format|
      if @origin.save
        format.html { redirect_to @origin, notice: "#{Origin.model_name.human.capitalize} criado com sucesso" }
        format.json { render :show, status: :created, location: @origin }
      else
        format.html { render :new }
        format.json { render json: @origin.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @origin.update(origin_params)
        format.html { redirect_to @origin, notice: "#{Origin.model_name.human.capitalize} atualizado com sucesso" }
        format.json { render :show, status: :ok, location: @origin }
      else
        format.html { render :edit }
        format.json { render json: @origin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @origin.destroy
    respond_to do |format|
      format.html { redirect_to origins_url, notice: "#{Origin.model_name.human.capitalize} excluido com sucesso"  }
      format.json { head :no_content }
    end
  end

  def create_origin_field
    @origin = Origin.find(params[:origin_field][:origin_id])
    @origin_field = OriginField.new(origin_field_params)

    if @origin_field.save
      redirect_to @origin, notice: "#{OriginField.model_name.human.capitalize} criado com sucesso"
    else
      render :new
    end
  end

  private

  def set_origin
    @origin = Origin.find(params[:id])
  end

  def origin_params
    params.require(:origin).permit(:file_name, :file_description, :created_in_sprint, :updated_in_sprint, :abbreviation, :base_type, :book_mainframe, :periodicity, :periodicity_details, :data_retention_type, :extractor_file_type, :room_1_notes, :mnemonic, :cd5_portal_origin_code, :cd5_portal_origin_name, :cd5_portal_destination_code, :cd5_portal_destination_name, :hive_table_name, :mainframe_storage_type, :room_2_notes)
  end

  def set_origin_field
    @origin_field = OriginField.find(params[:id])
  end

  def origin_field_params
    params.require(:origin_field).permit(:field_name, :origin_pic, :data_type_origin_field, :fmbase_format_type, :generic_data_type, :decimal_origin_field, :mask_origin_field, :position_origin_field, :width_origin_field, :is_key, :will_use, :has_signal, :room_1_notes, :cd5_variable_number, :cd5_output_order, :cd5_variable_name, :cd5_origin_format, :cd5_origin_format_desc, :cd5_format, :cd5_format_desc, :default_value, :room_2_notes, :origin_id)
  end

  #def room1_params
    #params.require(:origin).permit(:file_name, :file_description, :created_in_sprint, :updated_in_sprint, :abbreviation, :base_type, :book_mainframe, :periodicity, :periodicity_details, :data_retention_type, :extractor_file_type, :room_1_notes, :mnemonic, :cd5_portal_origin_code, :cd5_portal_origin_name, :cd5_portal_destination_code, :cd5_portal_destination_name, :hive_table_name, :mainframe_storage_type, :room_2_notes)
  #end

  #def room2_params
    #params.require(:origin).permit(:file_name, :file_description, :created_in_sprint, :updated_in_sprint, :abbreviation, :base_type, :book_mainframe, :periodicity, :periodicity_details, :data_retention_type, :extractor_file_type, :room_1_notes, :mnemonic, :cd5_portal_origin_code, :cd5_portal_origin_name, :cd5_portal_destination_code, :cd5_portal_destination_name, :hive_table_name, :mainframe_storage_type, :room_2_notes)
  #end
end
