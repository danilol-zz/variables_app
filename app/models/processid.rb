class Processid < ActiveRecord::Base
  before_save :calculate_field_var_table_name
  before_save :calculate_field_routine_name
  has_and_belongs_to_many :variables

  attr_accessor :variable_list

  scope :draft,       -> { where(status: Constants::STATUS[:SALA1]) }
  scope :development, -> { where(status: Constants::STATUS[:SALA2]) }
  scope :done,        -> { where(status: Constants::STATUS[:PRODUCAO]) }

  def code
    "PR#{self.id.to_s.rjust(3,'0')}"
  end

  def set_variables(variable_list = nil)
    self.variables = []

    variable_list.to_a.each { |var| self.variables << Variable.find(var.first) }
  end

  def status_screen_name
    mnemonic[0..19] if mnemonic?
  end

  private

  def calculate_field_var_table_name
    self.var_table_name = self.mnemonic? ? "VAR_#{mnemonic}".upcase : nil
  end

  def calculate_field_routine_name
    self.routine_name = self.process_number? ? "CD5PV#{process_number}" : nil
  end
end
