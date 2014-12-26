module ApplicationHelper
  def this_model_name( model )
    model.model_name.human.mb_chars.capitalize
  end
  def boolean_to_sim_nao( boolean_value )
    sim_nao = boolean_value ? Constants::YES_NO[0][0] : Constants::YES_NO[1][0]
    return sim_nao
  end
end
