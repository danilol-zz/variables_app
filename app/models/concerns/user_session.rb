module UserSession
  extend ActiveSupport::Concern

  attr_accessor :current_user_id

  def current_user
    User.find(current_user_id)
  end

  def current_user_is_room1?
    current_user.profile == 'room1'
  end

  def current_user_is_room2?
    current_user.profile == 'room2'
  end
end
