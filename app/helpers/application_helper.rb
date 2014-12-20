module ApplicationHelper
  def this_model_name( model )
    model.model_name.human.mb_chars.upcase
  end
end
