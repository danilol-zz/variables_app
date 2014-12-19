class Variable < ActiveRecord::Base
  include UserSession

  has_and_belongs_to_many :campaigns
  has_and_belongs_to_many :tables
  has_and_belongs_to_many :processids
  has_and_belongs_to_many :origin_fields

  scope :draft,       -> { where(status: Constants::STATUS[:SALA1]) }
  scope :development, -> { where(status: Constants::STATUS[:SALA2]) }
  scope :done,        -> { where(status: Constants::STATUS[:EFETIVO]) }

  def code
    "VA#{self.id.to_s.rjust(3,'0')}"
  end

  def set_origin_fields(fields_list = nil, current_user_id=nil)

    if fields_list
      self.origin_fields = []

      fields_list.each do |f|
        origin_field = OriginField.find(f.first)
        origin_field.current_user_id = current_user_id

        self.origin_fields << origin_field
      end
    else
      self.origin_fields = []
    end
  end

  def status_screen_name
    unless name.nil?
      res = name[0..20]
    end
  end
end
