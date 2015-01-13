# encoding : utf-8
require 'rails_helper'

describe ScriptsController do
  before do
    session[:user_id] = User.create(user_attributes)
  end

  let(:user_attributes) {
    {
      :email    => "zekitow@gmail.com",
      :name     => "José Ribeiro",
      :profile  => "Sala 1",
      :password => "123456"
    }
  }

  describe "#index" do
    context "GET index when user clicks on link" do
      it "renders index" do
        get :index
        expect(response).to render_template(:index)
      end
    end
    context "POST index" do
      context "when user clicks on submit botton" do
        script_name = "Script MySql Cadastro Regra de Qualidade de Arquivo"
        context "with no parameters entered" do
          it "renders index" do
            post :index
            expect(response).to render_template(:index)
          end
        end
        context "with 1 parameter entered" do
          it "does not generate script" do
            post :index, { "sprint_number" => nil, "script_name" => script_name }
          end
        end
        context "with 2 parameters entered" do
          it "generates script" do
            post :index, { "sprint_number" => 1, "script_name" => script_name }
          end
        end
      end
    end
  end
end
