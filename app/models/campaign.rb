class Campaign < ActiveRecord::Base

  has_and_belongs_to_many :variables

  attr_accessor :variable_list

  scope :draft,       -> { where(status: Constants::STATUS[:SALA1])   }
  scope :development, -> { where(status: Constants::STATUS[:SALA2])   }
  scope :done,        -> { where(status: Constants::STATUS[:PRODUCAO]) }


  def code
    "CA#{self.id.to_s.rjust(3,'0')}"
  end

  def set_variables(variable_list = nil)
    self.variables = []

    variable_list.each { |var| self.variables << Variable.find(var.first) } if variable_list
  end

  def status_screen_name
    name[0..19] if name?
  end
end
