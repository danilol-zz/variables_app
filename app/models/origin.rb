class Origin < ActiveRecord::Base
  has_many :origin_fields

  def status_screen_name
    unless file_name.nil?
      res = file_name[0..20]
    end
  end

end
