# encoding : utf-8
require 'rails_helper'

describe UsersController do
  before do
    user = User.new(valid_attributes)
    controller.session[:user_id] = user.id
  end

  after { session[:user_id] = nil }

  let(:valid_attributes) {
    {
      :email    => "zekitow@gmail.com",
      :name     => "José Ribeiro",
      :profile  => "Sala 1",
      :password => "123456"
    }
  }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all users as @user" do
      user = User.create! valid_attributes
      session[:user_id] = user.id
      get :index, {}, valid_session
      expect(assigns(:users)).to eq([user])
    end
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      get :new, {}
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      session[:user_id] = user.id
      get :edit, {:id => user.to_param}
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, {:user => valid_attributes}
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, {:user => valid_attributes}
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "redirects to the created user" do
        post :create, {:user => valid_attributes}
        expect(response).to redirect_to(root_path)
      end
    end

    describe "with invalid params" do
      let(:invalid_attributes) {
        new_attributes = {
          :email => nil,
          :name => 'teste',
          :profile => 'teste',
          :password => 'teste',
          :role => 'teste',
          }
      }

      it "assigns a newly created but unsaved user as @user" do
        post :create, {:user => invalid_attributes}, valid_session
        expect(assigns(:user)).to be_a_new(User)
      end

      it "re-renders the 'new' template" do
        post :create, {:user => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        new_attributes = {
          :email => 'teste',
          :name => 'teste',
          :profile => 'teste',
          :password => 'teste',
          :password_confirmation => 'teste',
          :role => 'teste',
          }
      }

      it "updates the requested user" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => new_attributes}, valid_session
        user.reload
        #skip("Add assertions for updated state")
      end

      it "assigns the requested user as @user" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the user" do
        user = User.create! valid_attributes
        session[:user_id] = user.id
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        expect(response).to redirect_to(users_url({status: 'user', notice: 'Usuário atualizado com sucesso'}))
      end
    end

    describe "with invalid params" do
      let(:invalid_attributes) {
        new_attributes = {
          :email => nil,
          :name => 'teste',
          :profile => 'teste',
          :password => 'teste',
          :password_confirmation => 'teste1',
          :role => 'teste',
          }
      }

      it "assigns the user as @user" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => invalid_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        user = User.create! valid_attributes
        session[:user_id] = user.id
        put :update, {:id => user.to_param, :user => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "GET password" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      session[:user_id] = user.id
      get :password, {}
      expect(user.id).to eq(controller.session[:user_id])
    end
  end

  describe "PUT password_update" do
    describe "with valid params" do
      let(:user_request) { {'password' => "123", 'password_confirmation' => "123"} }

      it "updates the requested user" do
        user = User.create! valid_attributes
        session[:user_id] = user.id
        put :password_update, {:id => user.to_param, :user => user_request }
        user.reload
        expect(user.password).to eq ("202cb962ac59075b964b07152d234b70")
      end

      it "redirects to the user" do
        user = User.create! valid_attributes
        session[:user_id] = user.id
        put :password_update, {:id => user.to_param, :user => user_request }
        expect(response).to redirect_to(origins_path)
      end
    end

    describe "with invalid params" do
      let(:user_bad_request) { {'password' => "", 'password_confirmation' => "123" } }

      it "re-render password" do
        user = User.create! valid_attributes
        session[:user_id] = user.id
        put :password_update, {:id => user.to_param, :user => user_bad_request }
        expect(response).to render_template("password")
      end

      it "re-render password when password and confirmation were different" do
        user = User.create! valid_attributes
        session[:user_id] = user.id
        put :password_update, {:id => user.to_param, :user => user_bad_request }
        expect(response).to render_template("password")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      user = User.create! valid_attributes
      session[:user_id] = user.id
      expect {
        delete :destroy, {:id => user.to_param}, valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user = User.create! valid_attributes
      session[:user_id] = user.id
      delete :destroy, {:id => user.to_param}, valid_session
      expect(response).to redirect_to(users_url)
    end
  end
end
