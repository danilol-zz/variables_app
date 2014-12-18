class CreateTableTablesVariables < ActiveRecord::Migration
  def change
    create_table :tables_variables do |t|
      t.integer :table_id
      t.integer :variable_id
    end
  end
end
