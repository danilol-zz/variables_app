class Origin < ActiveRecord::Base
  has_many :origin_fields

  def code
    "OR#{self.id.to_s.rjust(3,'0')}"
  end

  STATUS = [ "Rascunho", "Desenvolvimento", "Finalizado" ]
  #scope :draft, -> { where(status: 'Rascunho').order( :id => :desc ) }
  #scope :development, -> { where(status: 'Desenvolvimento').order( :id => :desc ) }
  #scope :done, -> { where(status: 'Finalizado').order( :id => :desc ) }

  def status_screen_name
    unless file_name.nil?
      res = file_name[0..20]
    end
  end
end
