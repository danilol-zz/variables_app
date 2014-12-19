class TablesController < ApplicationController
  before_action :set_table, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_authentication


  # GET /tables/new
  def new
    @variables = Variable.order(:name)
    @table = Table.new
  end

  # GET /tables/1/edit
  def edit
    @variables = Variable.order(:name)
  end

  # POST /tables
  # POST /tables.json
  def create
    @table = Table.new(table_params)

    @table.set_variables(params[:table][:variable_list])

    respond_to do |format|
      if @table.save
        format.html { redirect_to root_path({ status: 'table', notice: "#{Table.model_name.human.capitalize} criada com sucesso" }) }
        format.json { render :show, status: :created, location: @table }
      else
        format.html { render :new }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tables/1
  # PATCH/PUT /tables/1.json
  def update
    @table.variables.delete_all

    @table.set_variables(params[:table][:variable_list])

    respond_to do |format|
      if @table.update(table_params)
        format.html { redirect_to root_path({ status: 'table', notice: "#{Table.model_name.human.capitalize} atualizada com sucesso" }) }
        format.json { render :show, status: :ok, location: @table }
      else
        format.html { render :edit }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tables/1
  # DELETE /tables/1.json
  def destroy
    @table.destroy
    respond_to do |format|
      format.html { redirect_to tables_url, notice: "#{Table.model_name.human.capitalize} excluida com sucesso" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_table
      @table = Table.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def table_params
      params.require(:table).permit(:logic_table_name, :name, :initial_volume, :growth_estimation, :created_in_sprint, :updated_in_sprint, :room_1_notes, :final_physical_table_name, :mirror_physical_table_name, :final_table_number, :mirror_table_number, :mnemonic, :routine_number, :master_base, :hive_table, :big_data_routine_name, :output_routine_name, :ziptrans_routine_name, :mirror_data_stage_routine_name, :final_data_stage_routine_name, :room_2_notes)
    end
end

