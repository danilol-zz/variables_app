class Variable < ActiveRecord::Base
  STATUS = [ "Rascunho", "Desenvolvimento", "Finalizado" ]

  scope :draft, -> { where(status: 'Rascunho') }
  scope :development, -> { where(status: 'Desenvolvimento') }
  scope :done, -> { where(status: 'Finalizado') }

  def code
    "VA#{self.id.to_s.rjust(3,'0')}"
  end

  def status_screen_name
    unless name.nil?
      res = name[0..20]
    end
  end

end
