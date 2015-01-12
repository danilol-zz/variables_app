# encoding : utf-8
require 'rails_helper'

describe WelcomeController do
  before { session[:user_id] = FactoryGirl.create(:user) }

  describe "#index" do
    context "GET index" do
      it "renders index" do
        get :index
        expect(response).to render_template(:index)
      end

      context "with less then 10 records" do
        it "assigns all origin as @origins" do
          origin1 = FactoryGirl.create(:origin, current_user_id: session[:user_id])
          origin2 = FactoryGirl.create(:origin, current_user_id: session[:user_id])

          get :index
          expect(assigns(:items)).to eq [[origin2, origin1], [], [] ]
        end
      end

      context "with more then 10 records" do
        it "assigns all origin as @origins" do
          origin1  = FactoryGirl.create(:origin, current_user_id: session[:user_id], updated_at: Time.now - 1.week)
          origin2  = FactoryGirl.create(:origin, current_user_id: session[:user_id], updated_at: Time.now - 10.minutes)
          origin3  = FactoryGirl.create(:origin, current_user_id: session[:user_id], updated_at: Time.now - 20.minutes)
          origin4  = FactoryGirl.create(:origin, current_user_id: session[:user_id], updated_at: Time.now - 7.hours)
          origin5  = FactoryGirl.create(:origin, current_user_id: session[:user_id], updated_at: Time.now - 3.hours)
          origin6  = FactoryGirl.create(:origin, current_user_id: session[:user_id], updated_at: Time.now - 1.days)
          origin7  = FactoryGirl.create(:origin, current_user_id: session[:user_id], updated_at: Time.now - 1.hour)
          origin8  = FactoryGirl.create(:origin, current_user_id: session[:user_id], updated_at: Time.now - 15.minutes)
          origin9  = FactoryGirl.create(:origin, current_user_id: session[:user_id], updated_at: Time.now - 5.days)
          origin10 = FactoryGirl.create(:origin, current_user_id: session[:user_id], updated_at: Time.now - 2.hours)
          origin11 = FactoryGirl.create(:origin, current_user_id: session[:user_id], updated_at: Time.now - 10.days)

          get :index
          expect(assigns(:items)).to eq [[origin2, origin8, origin3, origin7, origin10, origin5, origin4, origin6, origin9, origin1], [], [] ]
        end
      end
    end
  end
end
