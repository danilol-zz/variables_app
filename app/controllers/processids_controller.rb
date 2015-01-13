class ProcessidsController < ApplicationController
  before_action :set_processid, only: [:edit, :update]
  before_action :load_variables
  before_action :set_query_param, only: [:search]
  before_filter :ensure_authentication

  def index
    @processids = Processid.all.paginate(page: params[:page], per_page: 10)
  end

  def search
    @processids = Processid.where(@text_param).where(@status_param).paginate(page: params[:page], per_page: 10).to_a

    render :index
  end

  def new
    @processid = Processid.new
  end

  def edit
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
    status = params[:update_status] ? { status: params[:update_status] } : {}

    if params[:processid][:variable_list]
      @processid.variables.delete_all
      @processid.set_variables(params[:processid][:variable_list])
    end

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

  def load_variables
    @variables = Variable.order(:name)
  end

  def set_processid
    @processid = Processid.find(params[:id])
  end

  def set_query_param
    @text_param   = Processid.arel_table[:process_number].matches("%#{params[:text_param]}%").to_sql
    @status_param = Processid.arel_table[:status].matches("%#{params[:status_param]}%").to_sql
  end

  def processid_params
    params.require(:processid).permit(
      :process_number,
      :mnemonic,
      :routine_name,
      :var_table_name,
      :conference_rule,
      :acceptance_percent,
      :keep_previous_work,
      :counting_rule,
      :notes,
      :status).merge(current_user_id: current_user.id)
  end
end
