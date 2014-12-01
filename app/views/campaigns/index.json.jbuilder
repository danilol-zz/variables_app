json.array!(@campaigns) do |campaign|
  json.extract! campaign, :id, :ident, :name, :priority, :created_in_sprint, :updated_in_sprint, :campaign_origin, :channel, :communication_channel, :product, :description, :criterion, :exists_in_legacy, :automatic_routine, :factory_criterion_status, :prioritized_variables_qty, :complied_variables_qty, :process_type, :crm_room_suggestion, :it_status, :notes
  json.url campaign_url(campaign, format: :json)
end
