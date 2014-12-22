module VariablesHelper
  def can_reopen?(variable)
    @current_user.room1? && variable.status == Constants::STATUS[:PRODUCAO]
  end

  def can_finish_room1?(variable)
    return true if @current_user.room1? && variable.status == Constants::STATUS[:SALA1]
  end

  def can_finish_room2?(variable)
    return true if @current_user.room2? && variable.status == Constants::STATUS[:SALA2]
  end
end
