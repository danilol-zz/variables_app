class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.integer :ident
      t.string :name
      t.integer :priority
      t.integer :created_in_sprint
      t.integer :updated_in_sprint
      t.string :campaign_origin
      t.string :channel
      t.string :communication_channel
      t.string :product
      t.string :description
      t.string :criterion
      t.string :exists_in_legacy
      t.string :automatic_routine
      t.string :factory_criterion_status
      t.integer :prioritized_variables_qty
      t.integer :complied_variables_qty
      t.string :process_type
      t.string :crm_room_suggestion
      t.string :it_status
      t.string :variable_selection
      t.string :status
      t.string :notes

      t.timestamps
    end
  end
end
