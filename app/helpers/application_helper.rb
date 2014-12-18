module ApplicationHelper

	def this_model_name( model )
      model.model_name.human.upcase
    end

    def entity_row( entity )
	  content_tag( :td ) do
	    link_to( "#{entity.code} #{entity.status_screen_name}", entity )
	  end
  end

end
