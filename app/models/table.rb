class Table < ActiveRecord::Base
  before_save :calculate_field_hive_table
  before_save :calculate_field_big_data_routine_name
  before_save :calculate_field_output_routine_name
  before_save :calculate_field_ziptrans_routine_name
  before_save :calculate_field_mirror_data_stage_routine_name
  before_save :calculate_field_final_data_stage_routine_name
  has_and_belongs_to_many :variables

  attr_accessor :variable_list

  scope :draft,       -> { where(status: Constants::STATUS[:SALA1]) }
  scope :development, -> { where(status: Constants::STATUS[:SALA2]) }
  scope :done,        -> { where(status: Constants::STATUS[:PRODUCAO]) }


  def code
    "TA#{self.id.to_s.rjust(3,'0')}"
  end

  def set_variables(variable_list = nil)
    self.variables = []

    variable_list.to_a.each { |var| self.variables << Variable.find(var.first) }
  end

  def status_screen_name
    logic_table_name[0..19] if logic_table_name?
  end

  private

  def calculate_field_hive_table
    self.hive_table = self.mnemonic? ? "TAB_#{self.mnemonic}".upcase : nil
  end

  def calculate_field_output_routine_name
    self.output_routine_name = self.routine_number? ? "CD5PS#{self.routine_number}" : nil
  end

  def calculate_field_big_data_routine_name
    self.big_data_routine_name = self.routine_number? ? "CD5PT#{self.routine_number}" : nil
  end

  def calculate_field_ziptrans_routine_name
    self.ziptrans_routine_name = self.mnemonic? ? "CD5T5#{self.mnemonic}".upcase : nil
  end

  def calculate_field_mirror_data_stage_routine_name
    self.mirror_data_stage_routine_name = self.routine_number? ? "CD5PD#{self.routine_number}" : nil
  end

  def calculate_field_final_data_stage_routine_name
    self.final_data_stage_routine_name = self.routine_number? ? "CD5PE#{self.routine_number}" : nil
  end
end
