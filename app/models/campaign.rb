class Campaign < ActiveRecord::Base

  def status_screen_name
    unless name.nil?
      res = name[0..20]
    end
  end

end
