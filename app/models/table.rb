class Table < ActiveRecord::Base

  has_and_belongs_to_many :variables

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
end
