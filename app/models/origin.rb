class Origin < ActiveRecord::Base
  has_many :origin_fields

  scope :draft,       -> { where(status: Constants::STATUS[:SALA1]) }
  scope :development, -> { where(status: Constants::STATUS[:SALA2]) }
  scope :done,        -> { where(status: Constants::STATUS[:EFETIVO]) }

  validates :file_name,                   presence: true, length: { maximum: 50 }
  validates :file_description,            presence: true, length: { maximum: 200 }
  validates :created_in_sprint,           presence: true
  validates :updated_in_sprint,           presence: true
  validates :abbreviation,                presence: true, length: { maximum: 3 }
  validates :base_type,                   presence: true
  validates :book_mainframe,              length: { maximum: 10 }
  validates :periodicity,                 presence: true
  validates :periodicity_details,         length: { maximum: 50 }
  validates :data_retention_type,         presence: true
  validates :extractor_file_type,         presence: true
  validates :room_1_notes,                length: { maximum: 500 }
  validates :mnemonic,                    uniqueness: true, presence: true, length: { maximum: 4 }
  validates :cd5_portal_origin_code,      uniqueness: true, presence: true
  validates :cd5_portal_destination_code, uniqueness: true, presence: true
  validates :mainframe_storage_type,      presence: true
  validates :room_2_notes,                length: { maximum: 500 }
  validates :dmt_advice,                  length: { maximum: 200 }
  validates :dmt_classification,          presence: true
  validates :status,                      presence: true

  def code
    "OR#{self.id.to_s.rjust(3,'0')}"
  end

  def status_screen_name
    unless file_name.nil?
      res = file_name[0..20]
    end
  end
end
