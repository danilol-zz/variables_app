# encoding : utf-8
require 'rails_helper'

describe ScriptsController do
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
    it "render index" do
      user = User.create! valid_attributes
      session[:user_id] = user.id
      get :index, {}, valid_session
      expect(response.code).to eq("200")
    end
  end
end
