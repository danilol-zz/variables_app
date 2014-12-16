class ProcessidsController < ApplicationController
  before_action :set_processid, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_authentication

  # GET /processids
  # GET /processids.json
  def index
    @processids = Processid.all
  end

  # GET /processids/1
  # GET /processids/1.json
  def show
  end

  # GET /processids/new
  def new
    @processid = Processid.new
  end

  # GET /processids/1/edit
  def edit
  end

  # POST /processids
  # POST /processids.json
  def create
    @processid = Processid.new(processid_params)

    respond_to do |format|
      if @processid.save
        format.html { redirect_to root_path({ status: 'processid', notice: "#{Processid.model_name.human.capitalize} criado com sucesso" }) }
        format.json { render :show, status: :created, location: @processid }
      else
        format.html { render :new }
        format.json { render json: @processid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /processids/1
  # PATCH/PUT /processids/1.json
  def update
    respond_to do |format|
      if @processid.update(processid_params)
        format.html { redirect_to root_path({ status: 'processid', notice: "#{Processid.model_name.human.capitalize} atualizado com sucesso" }) }
        format.json { render :show, status: :ok, location: @processid }
      else
        format.html { render :edit }
        format.json { render json: @processid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /processids/1
  # DELETE /processids/1.json
  def destroy
    @processid.destroy
    respond_to do |format|
      format.html { redirect_to processids_url, notice: "#{Processid.model_name.human.capitalize} excluido com sucesso" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_processid
      @processid = Processid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def processid_params
      params.require(:processid).permit(:process_number, :mnemonic, :routine_name, :var_table_name, :conference_rule, :acceptance_percent, :keep_previous_work, :counting_rule, :notes)
    end
end
