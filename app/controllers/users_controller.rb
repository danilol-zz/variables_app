# encoding : utf-8
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  before_filter :ensure_authentication, :only => [:edit, :update, :destroy, :index, :show]
  before_filter :ensure_correct_user, :only => [:edit, :update]

  def index
    @users = User.order(:profile, :name, :role)
    @new_user = User.new
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # GET /users/1
  def show
  end

  # GET /password
  def password
    @user = current_user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = 'Seu usuário foi criado com sucesso!'
      redirect_to root_path
    else
      flash[:error] = "Less!! #{@user.errors.full_messages}"
      render action: "new", layout: false
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Usuário atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def password_update
    @user = current_user
    @user.password = User.md5(params[:user][:password])
    @user.password_confirmation = User.md5(params[:user][:password_confirmation])

    respond_to do |format|
      if !params[:user][:password].blank? and @user.save
        session[:user_id] = @user.id
        @user.reload
        @user.save
        format.html { redirect_to "/origins", notice: 'Sua senha foi alterada!' }
      else
        format.html { render action: "password", notice: 'Suas senhas não conferem!' }
      end
    end
  end

  def authenticate
    user = User.authenticate(params[:user][:email], params[:user][:password])

    if user
      session[:user_id] = user.id
      redirect_to "/origins", notice: "Olá #{user.name}, bem vindo ao Portal de Variáveis!"
    else
      redirect_to root_url, notice: 'Usuário ou senha inválida'
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_url, :alert => "Obrigado por ter usado o Portal de Variáveis!"
  end

  def ensure_correct_user
    raise TentandoSerEspertaoException  if !current_user.admin? && session[:user_id].to_s != params[:id].to_s
  end

  class TentandoSerEspertaoException < StandardError
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :name, :profile, :password, :password_confirmation, :role)
  end
end
