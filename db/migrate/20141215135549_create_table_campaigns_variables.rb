class CreateTableCampaignsVariables < ActiveRecord::Migration
  def change
    create_table :campaigns_variables, :id => false do |t|
      t.integer :campaign_id
      t.integer :variable_id
    end
  end
end

