module ApplicationHelper
  def this_model_name( model )
    model.model_name.human.mb_chars.capitalize
  end

  def boolean_to_sim_nao( boolean_value )
    boolean_value ? Constants::YES_NO[0][0] : Constants::YES_NO[1][0]
  end

  def entity_path
    @filter.to_s.downcase.pluralize
  end

  def capitalized_name(entity = nil)
    t("activerecord.models.#{entity.to_s.downcase}.one")
  end

  def status_screen_name(name = nil)
    name.to_s[0..19]
  end
end
