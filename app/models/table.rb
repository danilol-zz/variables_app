class Table < ActiveRecord::Base

  def code
    "TA#{self.id.to_s.rjust(3,'0')}"
  end

  def status_screen_name
    unless logic_table_name.nil?
      res = logic_table_name[0..20]
    end
  end

end
