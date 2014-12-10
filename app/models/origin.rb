class Origin < ActiveRecord::Base
  has_many :origin_fields

  STATUS = [ "Rascunho", "Desenvolvimento", "Finalizado" ]

  scope :draft, -> { where(status: 'Rascunho') }
  scope :development, -> { where(status: 'Desenvolvimento') }
  scope :done, -> { where(status: 'Finalizado') }

  def status_screen_name
    unless file_name.nil?
      res = file_name[0..20]
    end
  end
end
