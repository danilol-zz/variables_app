class Campaign < ActiveRecord::Base

  def code
    "CA#{self.id.to_s.rjust(3,'0')}"
  end

  def status_screen_name
    unless name.nil?
      res = name[0..20]
    end
  end

end
