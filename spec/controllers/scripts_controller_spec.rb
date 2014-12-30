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
    context "GET index" do
      it "renders index" do
        get :index
        expect(response).to render_template(:index)
      end
    end
    context "POST index" do
      it "renders index" do
        post :index
        expect(response).to render_template(:index)
      end
    end
  end

end
