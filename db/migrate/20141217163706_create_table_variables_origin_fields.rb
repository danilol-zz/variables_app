class CreateTableVariablesOriginFields < ActiveRecord::Migration
  def change
    create_table :origin_fields_variables do |t|
      t.integer :variable_id
      t.integer :origin_field_id
    end
  end
end
