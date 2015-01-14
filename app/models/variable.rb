class Variable < ActiveRecord::Base
  include UserSession

  has_and_belongs_to_many :campaigns
  has_and_belongs_to_many :tables
  has_and_belongs_to_many :processids
  has_and_belongs_to_many :origin_fields

  scope :draft,       -> { where(status: Constants::STATUS[:SALA1]) }
  scope :development, -> { where(status: Constants::STATUS[:SALA2]) }
  scope :done,        -> { where(status: Constants::STATUS[:PRODUCAO]) }

  scope :recent,      -> { order(updated_at: :desc) }

  validates :data_type,              inclusion: { in: Constants::DATA_TYPE }
  validates :sas_update_periodicity, inclusion: { in: Constants::SAS_UPDATE_PERIODICITY }
  validates :domain_type,            inclusion: { in: Constants::DOMAIN_TYPE }
  validates :sas_data_model_status,  inclusion: { in: Constants::SAS_DATA_MODEL_STATUS }
  validates :drs_variable_status,    inclusion: { in: Constants::DRS_VARIABLE_STATUS }
  #validates :variable_type,          inclusion: { in: Constants::VARIABLE_TYPE }, if: :current_user_is_room2?

  def code
    "VA#{self.id.to_s.rjust(3,'0')}"
  end

  def set_origin_fields(fields_list = nil, current_user_id = nil)
    self.origin_fields = []

    if fields_list

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
    name[0..19] if name?
  end
end
