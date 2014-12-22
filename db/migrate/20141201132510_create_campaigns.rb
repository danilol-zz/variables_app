class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string  :ident
      t.string  :name, length: 50
      t.string  :priority
      t.string  :campaign_origin, length: 50
      t.integer :created_in_sprint
      t.integer :updated_in_sprint
      t.string  :channel, length: 50
      t.string  :communication_channel, length: 50
      t.string  :product, length: 50
      t.text    :description, length: 200
      t.text    :criterion, length: 500
      t.boolean  :exists_in_legacy
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
