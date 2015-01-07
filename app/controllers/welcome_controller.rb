class WelcomeController < ApplicationController
  def index
    @filter = params[:status] || 'origin'

    @items = case @filter
             when "origin"
               [Origin.select(:id, :status, :file_name).draft.recent.limit(10),
                Origin.select(:id, :status, :file_name).development.recent.limit(10),
                Origin.select(:id, :status, :file_name).done.recent.limit(10)]
             when "campaign"
               [Campaign.select(:id, :status, :name).draft.recent.limit(10),
                Campaign.select(:id, :status, :name).development.recent.limit(10),
                Campaign.select(:id, :status, :name).done.recent.limit(10)]
             when "variable"
               [Variable.select(:id, :status, :name).draft.recent.limit(10),
                Variable.select(:id, :status, :name).development.recent.limit(10),
                Variable.select(:id, :status, :name).done.recent.limit(10)]
             when "table"
               [Table.select(:id, :status, :logic_table_name).draft.recent.limit(10),
                Table.select(:id, :status, :logic_table_name).development.recent.limit(10),
                Table.select(:id, :status, :logic_table_name).done.recent.limit(10)]
             when "processid"
               [Processid.select(:id, :status, :mnemonic).draft.recent.limit(10),
                Processid.select(:id, :status, :mnemonic).development.recent.limit(10),
                Processid.select(:id, :status, :mnemonic).done.recent.limit(10)]
             end

    @max_size = [@items[0].size, @items[1].size, @items[2].size].max
  end
end
