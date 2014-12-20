class ProcessidsController < ApplicationController
  before_action :set_processid, only: [:edit, :update]
  before_filter :ensure_authentication

  def new
    @variables = Variable.order(:name)
    @processid = Processid.new
  end

  def edit
    @variables = Variable.order(:name)
  end

  def create
    @processid = Processid.new(processid_params.merge(status: Constants::STATUS[:SALA2]))

    @processid.set_variables(params[:processid][:variable_list])

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

  def update
    @processid.variables.delete_all

    status = params[:update_status] ? { status: params[:update_status] } : {}

    @processid.set_variables(params[:processid][:variable_list])

    respond_to do |format|
      if @processid.update(processid_params.merge(status))
        format.html { redirect_to root_path({ status: 'processid', notice: "#{Processid.model_name.human.capitalize} atualizado com sucesso" }) }
        format.json { render :show, status: :ok, location: @processid }
      else
        format.html { render :edit }
        format.json { render json: @processid.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_processid
    @processid = Processid.find(params[:id])
  end

  def processid_params
    params.require(:processid).permit(:process_number, :mnemonic, :routine_name, :var_table_name, :conference_rule, :acceptance_percent, :keep_previous_work, :counting_rule, :notes)
  end
end
