class CreateProcessids < ActiveRecord::Migration
  def change
    create_table :processids do |t|
      t.string  :process_number
      t.string  :mnemonic
      t.string  :routine_name
      t.string  :var_table_name
      t.string  :conference_rule
      t.string  :acceptance_percent
      t.boolean  :keep_previous_work
      t.string  :counting_rule
      t.text    :notes
      t.string  :status

      t.timestamps
    end
  end
end
