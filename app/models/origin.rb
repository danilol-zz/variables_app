class Origin < ActiveRecord::Base
  has_many :origin_fields

  scope :draft,       -> { where(status: Constants::STATUS[:SALA1]) }
  scope :development, -> { where(status: Constants::STATUS[:SALA2]) }
  scope :done,        -> { where(status: Constants::STATUS[:EFETIVO]) }

  def code
    "OR#{self.id.to_s.rjust(3,'0')}"
  end

  def status_screen_name
    unless file_name.nil?
      res = file_name[0..20]
    end
  end
end
