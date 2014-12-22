class OriginsController < ApplicationController
  before_action :set_origin, only: [:show, :edit, :update]
  before_filter :ensure_authentication

  def show
    @origin_field = OriginField.new
  end

  def new
    @origin = Origin.new
  end

  def edit
  end

  def create
    @origin = Origin.new(origin_params.merge(status: Constants::STATUS[:SALA1]))

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
    old_status = @origin.status
    status = params[:update_status] ? { status: params[:update_status] } : {}

    respond_to do |format|
      if @origin.update(origin_params.merge(status))
        format.html { redirect_to root_path, notice: "#{Origin.model_name.human.capitalize} atualizado com sucesso" }
        format.json { render :show, status: :ok, location: @origin }
      else
        @origin.status = old_status
        format.html { render :edit }
        format.json { render json: @origin.errors, status: :unprocessable_entity }
      end
    end
    set_desabled_fields
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

  def create_origin_field_upload
    @origin = Origin.find(params[:origin_field][:origin_id])
    @file_type = params[:file_type]
    @data_file = params[:origin_field][:datafile]

    array_linha = Array.new
    conta_linha = 0
    conta_valido = 0

    resultado = false

    # abre o arquivo temporario
    File.open(@data_file.tempfile) do |txt|
      txt.each_line() do |linha|

        # ignora o header e linhas vazias para oa arquivos do hadoop
        array_linha = linha.split(",")
        if @file_type == "hadoop" && array_linha.size > 1 && conta_linha > 0
          resultado = OriginField.text_parser(@file_type, linha, @origin.id, current_user.id)
          conta_valido += 1
        elsif (!linha.downcase.include? "end of data") && @file_type == "mainframe"
          resultado = OriginField.text_parser(@file_type, linha, @origin.id, current_user.id)
          if resultado
            conta_valido += 1
          end
        end

        conta_linha += 1
      end
    end

    if resultado || conta_valido > 0
      redirect_to @origin, notice: "#{conta_valido} #{OriginField.model_name.human.capitalize} criados com sucesso"
    else
      redirect_to @origin, notice: "Nenhum #{OriginField.model_name.human.capitalize} foi criado!"
    end
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
    ).merge(current_user_id: current_user.id)
  end

  def set_origin_field
    @origin_field = OriginField.find(params[:id])
  end

  def origin_field_params
    params.require(:origin_field).permit(
      :field_name,
      :origin_pic,
      :data_type,
      :fmbase_format_type,
      :generic_data_type,
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
      :cd5_variable_name,
      :cd5_origin_format,
      :cd5_origin_format_desc,
      :cd5_format,
      :cd5_format_desc,
      :default_value,
      :room_2_notes,
      :domain,
      :dmt_notes,
      :fmbase_format_datyp,
      :generic_datyp,
      :cd5_origin_frmt_datyp,
      :cd5_frmt_origin_desc_datyp,
      :default_value_datyp,
      :origin_id
    ).merge(current_user_id: current_user.id)
  end
end
