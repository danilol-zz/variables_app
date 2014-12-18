class OriginField < ActiveRecord::Base
  belongs_to :origin

  def self.text_parser(origin_type, text_value)
  		
  		return_value=nil
  		
  		#arquivo mainframe / tabela mainframe / base hadoop / outro
  		
  		case origin_type
  		when "arquivo mainframe", "tabela mainframe"
  			return_value=text_parser_mainframe(text_value) 
  		when "base hadoop" , "outro"
  			return_value=text_parser_generico(text_value) 
  		end
  				
  		
  		return_value
  end
  def self.text_parser_mainframe(text_value) 
     captura = /(.{0,5})(.{0,40})(.{0,10})(.{0,8})(.{0,6})(.{0,6})(.{0,6})/.match(text_value)
     
     p "======"

     p captura
     p "----"
     p /^[0-9]+\ ([A-Za-z0-9]+)$/.match(captura[2].strip)
     p "---"


     field_name = ""
     origin_pic = ""
     fmbase_value = ""
     position = ""
     width = ""
     value_return = nil

     ind_comma=""
     data_type=""
  
     p '---'
     p captura[2]
     p captura[2].strip
     p /^[0-9]+\ ([A-Za-z0-9]+)[A-Za-z0-9\ ]*$/.match(captura[2].strip)
     #p /^[0-9]+\ ([A-Za-z0-9]+)$/.match(captura[2].strip)[1]

     	unless ( captura[7].empty? ) || 
     	       (/^[0-9]+\ ([A-Za-z0-9]+)[A-Za-z0-9\ ]*$/.match(captura[2].strip).nil? )  
     		
     		field_name = /^[0-9]+\ ([A-Za-z0-9]+)[A-Za-z0-9\ ]*$/.match(captura[2].strip)[1]
         	origin_pic = captura[3].strip
         	fmbase_value = captura[4].strip
         	position = captura[5].strip
         	width = captura[7].strip
          
          if origin_pic.empty?
            origin_pic = "X(" + width + ")"
          end
         	p /^AN|ZD|BI|PD$/.match(fmbase_value)
         	p "--"
         	unless /[V]/.match(origin_pic).nil?
    			ind_comma = true
		 	else
    			ind_comma = false
		 	end

		    if ind_comma 
    			if fmbase_value ==  "ZD"
        			data_type="numerico com virgula"
    		 	elsif fmbase_value == "PD"
        			data_type="compactado com virgula"
    		 	else
        			data_type=""
    		 	end 
		 	else
    			if fmbase_value ==  "ZD"
        			data_type="numerico"
    		 	elsif fmbase_value == "PD"
        			data_type="compactado"
    		 	elsif fmbase_value == "BI"
        			data_type="binario mainframe"
    		 	elsif fmbase_value == "AN"
        			data_type="alfanumerico"
    		 	else
        			data_type=""
    	 		end
     		end
        end    
        
        unless
           (/^[0-9A-Za-z\ \_\-]+$/.match(field_name).nil?) ||
           (/^AN|ZD|BI|PD$/.match(fmbase_value).nil?) ||
           ( 
              (/^[X]+$/.match(origin_pic).nil?) && 
              (/^X\([0-9]+\)$/.match(origin_pic).nil?) && 
              (/^S{0,1}[9]+$/.match(origin_pic).nil?) && 
              (/^S{0,1}[9]\([0-9]+\)$/.match(origin_pic).nil?) && 
              (/^S{0,1}[9]+V[9]+$/.match(origin_pic).nil?) && 
              (/^S{0,1}[9]+V[9]\([0-9]+\)$/.match(origin_pic).nil?)  &&
              (/^S{0,1}[9]\([0-9]+\)V[9]+$/.match(origin_pic).nil?) && 
              (/^S{0,1}[9]\([0-9]+\)V[9]\([0-9]+\)$/.match(origin_pic).nil?)  
           )  ||
           (/^[0-9]+$/.match(position).nil?) || 
           (/^[0-9]+$/.match(width).nil?) 

         p "--------"
         p "vou montar!!"

         origin_field = OriginField.new
         origin_field.field_name = field_name
         origin_field.origin_pic = origin_pic
         origin_field.data_type = data_type
         origin_field.position = position
         origin_field.width = width
    
         origin_field.save
    
         value_return = origin_field
        
        end
  
      	value_return
 	end

  	def self.text_parser_generico(text_value)
		
		return_value=nil
		
		unless (/^(\"[a-zA-Z0-9\_\-\<\>]*\"\,){3}(\"[a-zA-Z0-9\_\-\<\>]*\")$/.match(text_value).nil?)
			
			field_name=text_value.gsub('"', '').split(',').first
			
			origin_field = OriginField.new
            origin_field.field_name = field_name
            origin_field.origin_pic = "X(255)"
            origin_field.data_type = "alfanumerico"
            origin_field.position = 0
            origin_field.width = 0
    
            origin_field.save
    
            return_value = origin_field
	    end

		return_value
	end

end
  

