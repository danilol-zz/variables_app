class Campaign < ActiveRecord::Base
  include UserSession

  has_and_belongs_to_many :variables

  attr_accessor :variable_list

  scope :draft,       -> { where(status: Constants::STATUS[:SALA1])   }
  scope :development, -> { where(status: Constants::STATUS[:SALA2])   }
  scope :done,        -> { where(status: Constants::STATUS[:PRODUCAO]) }

  scope :recent,      -> { order(updated_at: :desc) }

  validates :name, presence: true, if: :current_user_is_room1?
  validates :name, length: { maximum: 50 }, if: :current_user_is_room1?
  validates :priority, presence: true, if: :current_user_is_room1?
  validates :campaign_origin, presence: true, if: :current_user_is_room1?
  validates :campaign_origin, length: { maximum: 50 }, if: :current_user_is_room1?
  validates :created_in_sprint, presence: true, if: :current_user_is_room1?
  validates :updated_in_sprint, presence: true, if: :current_user_is_room1?
  validates :channel, presence: true, if: :current_user_is_room1?
  validates :channel, length: { maximum: 50 }, if: :current_user_is_room1?
  validates :communication_channel, presence: true, if: :current_user_is_room1?
  validates :communication_channel, length: { maximum: 50 }, if: :current_user_is_room1?
  validates :product, presence: true, if: :current_user_is_room1?
  validates :product, length: { maximum: 50 }, if: :current_user_is_room1?
  validates :criterion, presence: true, if: :current_user_is_room1?
  validates :criterion, length: { maximum: 500 }, if: :current_user_is_room1?
  validates :description, presence: true, if: :current_user_is_room1?
  validates :description, length: { maximum: 200 }, if: :current_user_is_room1?
  validates_inclusion_of :exists_in_legacy, in: [true, false], if: :current_user_is_room1?
  validates :automatic_routine, presence: true, length: { maximum: 50 }, if: lambda { current_user_is_room1? && self.exists_in_legacy }
  validates :factory_criterion_status, presence: true, inclusion: { in: Constants::FACTORY_CRITERION_STATUS }
  validates :it_status, presence: true, if: :current_user_is_room1?

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
