class CreateTableProcessidsVariables < ActiveRecord::Migration
  def change
    create_table :processids_variables do |t|
      t.integer :processid_id
      t.integer :variable_id
    end
  end
end
