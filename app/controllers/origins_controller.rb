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
    set_desabled_fields
  end

  def destroy
    @origin.destroy
    respond_to do |format|
      format.html { redirect_to origins_url, notice: "#{Origin.model_name.human.capitalize} excluido com sucesso"  }
      format.json { head :no_content }
    end
  end

  def create_or_update_origin_field
    @origin         = Origin.find(params[:origin_field][:origin_id])
    origin_field_id = params[:origin_field][:origin_field_id]
    if origin_field_id.blank?
      @origin_field = OriginField.new(origin_field_params)
    else
      if ( @origin_field = OriginField.find(origin_field_id) )
        @origin_field.update(origin_field_params.merge!( :id => origin_field_id ))
      end
    end
    if @origin_field.save
      redirect_to @origin, notice: "#{OriginField.model_name.human.capitalize} criado com sucesso"
    else
      render :new
    end
  end

  def destroy_origin_field
    origin_field_id = params[:format]
    unless origin_field_id.empty?
      if ( @origin_field = OriginField.find(origin_field_id) )
        @origin          = Origin.find(@origin_field.origin_id)
        if @origin_field.destroy
          redirect_to @origin, notice: "#{OriginField.model_name.human.capitalize} excluido com sucesso"
        else
          render :new
        end   
      end
    end
  end

  def get_origin_field_to_update
    @origin_field = OriginField.find(params[:format])
    @origin       = Origin.find(@origin_field.origin_id)
    set_desabled_fields
    render :show
  end

  private

  def set_desabled_fields
    if @current_user.profile == User::ROOM1
      @disabled_for_room1 = "false"
    else 
      @disabled_for_room1 = "true"
    end 
    if @current_user.profile == User::ROOM2
      @disabled_for_room2 = "false"
    else 
      @disabled_for_room2 = "true"
    end        
  end

  def set_origin
    @origin = Origin.find(params[:id])
  end

  def origin_params
    params.require(:origin).permit(
      :file_name,
      :file_description,
      :created_in_sprint,
      :updated_in_sprint,
      :abbreviation,
      :base_type,
      :book_mainframe,
      :periodicity,
      :periodicity_details,
      :data_retention_type,
      :extractor_file_type,
      :room_1_notes,
      :mnemonic,
      :cd5_portal_origin_code,
      :cd5_portal_origin_name,
      :cd5_portal_destination_code,
      :cd5_portal_destination_name,
      :hive_table_name,
      :mainframe_storage_type,
      :room_2_notes,
      :dmt_advice,
      :dmt_classification,
      :status
    )
  end

  def set_origin_field
    @origin_field = OriginField.find(params[:id])
  end

  def origin_field_params
    params.require(:origin_field).permit(
      :field_name,      
      :origin_pic,
      :data_type,
      :decimal,
      :mask,
      :position,
      :width,
      :is_key,
      :will_use,
      :has_signal,
      :room_1_notes,
      :cd5_variable_number,
      :cd5_output_order,
      :room_2_notes,
      :domain,
      :dmt_notes,
      :fmbase_format_datyp,
      :generic_datyp,
      :cd5_origin_frmt_datyp,
      :cd5_frmt_origin_desc_datyp,
      :default_value_datyp,
      :origin_id
    )
  end

end
