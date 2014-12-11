class Variable < ActiveRecord::Base

  def code
    "VA#{self.id.to_s.rjust(3,'0')}"
  end

  def status_screen_name
    unless name.nil?
      res = name[0..20]
    end
  end

end
