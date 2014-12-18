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
  scope :done,        -> { where(status: Constants::STATUS[:EFETIVO]) }

  def code
    "TA#{self.id.to_s.rjust(3,'0')}"
  end

  def set_variables(variable_list = nil)
    if variable_list
      self.variables = []
      variable_list.each { |var| self.variables << Variable.find(var.first) }
    else
      self.variables = []
    end
  end

  def status_screen_name
    unless name.nil?
      res = name[0..20]
    end
  end

  def calculate_field_hive_table
    if self.mnemonic?
      self.hive_table = "TAB_#{self.mnemonic}".upcase
    else
      self.hive_table = nil
    end
  end

  def calculate_field_output_routine_name
    if self.routine_number?
      self.output_routine_name = "CD5PS#{self.routine_number}"
    else
      self.output_routine_name = nil
    end
  end

  def calculate_field_big_data_routine_name
    if self.routine_number?
      self.big_data_routine_name = "CD5PT#{self.routine_number}"
    else
      self.big_data_routine_name = nil
    end
  end

  def calculate_field_ziptrans_routine_name
    if self.mnemonic?
      self.ziptrans_routine_name = "CD5T5#{self.mnemonic}"
    else
      self.ziptrans_routine_name = nil
    end
  end

  def calculate_field_mirror_data_stage_routine_name
    if self.routine_number?
      self.mirror_data_stage_routine_name = "CD5PD#{self.routine_number}"
    else
      self.mirror_data_stage_routine_name = nil
    end
  end

  def calculate_field_final_data_stage_routine_name
    if self.routine_number?
      self.final_data_stage_routine_name = "CD5PE#{self.routine_number}"
    else
      self.final_data_stage_routine_name = nil
    end
  end
end
