class Processid < ActiveRecord::Base

  def code
    "PR#{self.id.to_s.rjust(3,'0')}"
  end

  def status_screen_name
    unless mnemonic.nil?
      res = mnemonic[0..20]
    end
  end

end
