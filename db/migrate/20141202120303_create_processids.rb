class CreateProcessids < ActiveRecord::Migration
  def change
    create_table :processids do |t|
      t.integer :process_number
      t.string  :mnemonic
      t.string  :routine_name
      t.string  :var_table_name
      t.string  :conference_rule
      t.string  :acceptance_percent
      t.string  :keep_previous_work
      t.string  :counting_rule
      t.string  :notes
      t.string  :status      

      t.timestamps
    end
  end
end
