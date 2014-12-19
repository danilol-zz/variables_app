class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string  :ident
      t.string  :name
      t.string  :priority
      t.string  :campaign_origin
      t.integer :created_in_sprint
      t.integer :updated_in_sprint
      t.string  :channel
      t.string  :communication_channel
      t.string  :product
      t.text    :criterion
      t.string  :exists_in_legacy
      t.string  :automatic_routine
      t.string  :factory_criterion_status
      t.string  :process_type
      t.text    :crm_room_suggestion
      t.string  :it_status
      t.string  :notes
      t.string  :owner
      t.string  :status

      t.timestamps
    end
  end
end
