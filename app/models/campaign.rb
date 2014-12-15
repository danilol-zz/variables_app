class Campaign < ActiveRecord::Base

  has_and_belongs_to_many :variables

  attr_accessor :variable_list

  scope :draft,       -> { where(status: Constants::STATUS[:SALA1])   }
  scope :development, -> { where(status: Constants::STATUS[:SALA2])   }
  scope :done,        -> { where(status: Constants::STATUS[:EFETIVO]) }


  def code
    "CA#{self.id.to_s.rjust(3,'0')}"
  end

  def status_screen_name
    unless name.nil?
      res = name[0..20]
    end
  end
end
