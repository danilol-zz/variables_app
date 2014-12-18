module ApplicationHelper
  def this_model_name( model )
    model.model_name.human.upcase
  end
end
