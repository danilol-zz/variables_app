class Origin < ActiveRecord::Base
  include UserSession

  before_save :calculate_hive_table_name
  before_save :calculate_cd5_portal_destination_name
  before_save :calculate_cd5_portal_origin_name

  has_many :origin_fields

  scope :draft,       -> { where(status: Constants::STATUS[:SALA1]) }
  scope :development, -> { where(status: Constants::STATUS[:SALA2]) }
  scope :done,        -> { where(status: Constants::STATUS[:PRODUCAO]) }

  scope :recent, -> { order(updated_at: :desc) }

  # room1 validations
  validates :file_name,                   presence: true, length: { maximum: 50 }, if: :current_user_is_room1?
  validates :file_description,            presence: true, length: { maximum: 200 }, if: :current_user_is_room1?
  validates :created_in_sprint,           presence: true, if: :current_user_is_room1?
  validates :updated_in_sprint,           presence: true, if: :current_user_is_room1?
  validates :abbreviation,                presence: true, length: { maximum: 3 }, if: :current_user_is_room1?
  validates :base_type,                   presence: true, if: :current_user_is_room1?
  validates :book_mainframe,              length: { maximum: 10 }, if: :current_user_is_room1?
  validates :periodicity,                 presence: true, if: :current_user_is_room1?
  validates :periodicity_details,         length: { maximum: 50 }, if: :current_user_is_room1?
  validates :data_retention_type,         presence: true, if: :current_user_is_room1?
  validates :dmt_advice,                  length: { maximum: 200 }, if: :current_user_is_room1?
  validates :dmt_classification,          presence: true, if: :current_user_is_room1?
  validates :extractor_file_type,         presence: true, if: :current_user_is_room1?
  validates :room_1_notes,                length: { maximum: 500 }, if: :current_user_is_room1?
  validates :dmt_advice,                  length: { maximum: 200 }, if: :current_user_is_room1?
  validates :dmt_classification,          presence: true, if: :current_user_is_room1?
  validates :status,                      presence: true

  # room2 validations
  validates :mnemonic,                    uniqueness: true, presence: true, length: { maximum: 4 }, if: :current_user_is_room2?
  validates :cd5_portal_origin_code,      uniqueness: true, presence: true, if: :current_user_is_room2?
  validates :cd5_portal_destination_code, uniqueness: true, presence: true, if: :current_user_is_room2?
  validates :mainframe_storage_type,      presence: true, if: :current_user_is_room2?
  validates :room_2_notes,                length: { maximum: 500 }, if: :current_user_is_room2?

  def code
    "OR#{self.id.to_s.rjust(3,'0')}"
  end

  def status_screen_name
    file_name[0..19] if file_name?
  end

  private

  def calculate_hive_table_name
    self.hive_table_name = self.mnemonic? ? "ORG_#{self.mnemonic}".upcase : nil
  end

  def calculate_cd5_portal_destination_name
    self.cd5_portal_destination_name = self.mnemonic? ? "CD5.RETR.B#{self.mnemonic}".upcase : nil
  end

  def calculate_cd5_portal_origin_name
    self.cd5_portal_origin_name = self.mnemonic? ? "CD5.BASE.O#{self.mnemonic}".upcase : self.cd5_portal_origin_name = nil
  end
end
