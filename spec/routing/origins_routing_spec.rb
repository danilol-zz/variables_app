require "rails_helper"

RSpec.describe OriginsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/origins").to route_to("origins#index")
    end

    it "routes to #new" do
      expect(:get => "/origins/new").to route_to("origins#new")
    end

    it "routes to #show" do
      expect(:get => "/origins/1").to route_to("origins#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/origins/1/edit").to route_to("origins#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/origins").to route_to("origins#create")
    end

    it "routes to #update" do
      expect(:put => "/origins/1").to route_to("origins#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/origins/1").to route_to("origins#destroy", :id => "1")
    end

  end
end
