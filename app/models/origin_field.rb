class OriginField < ActiveRecord::Base
  include UserSession
  before_save :calculate_field_fmbase_format_type
  before_save :calculate_field_generic_data_type
  before_save :calculate_field_cd5_variable_name
  before_save :calculate_field_cd5_origin_format
  before_save :calculate_field_cd5_origin_format_desc
  before_save :calculate_field_default_value
  before_save :calculate_field_cd5_format_desc
  before_save :calculate_field_cd5_format

  belongs_to :origin

  validates :field_name, presence: true, if: :current_user_is_room1?


  def self.text_parser(origin_type, text_value, origin_id, current_user_id)

      return_value=nil

      # remove quebra de linha windows
      text_value = text_value.gsub(/\n/, '').gsub(/\r/, '')

      #arquivo ou tabela mainframe / hadoop / outro
      case origin_type
        when "mainframe"
          return_value=text_parser_mainframe(text_value, origin_id, current_user_id)
        when "hadoop" , "outro"
          return_value=text_parser_generico(text_value, origin_id, current_user_id) 
      end

      return_value
  end

  def self.text_parser_mainframe(text_value, origin_id, current_user_id) 
     captura = /(.{0,5})(.{0,40})(.{0,10})(.{0,8})(.{0,6})(.{0,6})(.{0,6})/.match(text_value)
     
     field_name = ""
     origin_pic = ""
     fmbase_value = ""
     position = ""
     width = ""
     value_return = nil

     ind_comma=""
     data_type=""
  
     

      unless ( captura[7].empty? ) || 
             (/^[0-9]+\ ([A-Za-z0-9]+)[A-Za-z0-9\ ]*$/.match(captura[2].strip).nil? )  
        
        field_name = /^[0-9]+\ ([A-Za-z0-9]+)[A-Za-z0-9\ ]*$/.match(captura[2].strip)[1]
          origin_pic = captura[3].strip
          fmbase_value = captura[4].strip
          position = captura[5].strip
          width = captura[7].strip

          if origin_pic.empty?
            origin_pic = "X(#{width})" 
          end

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

         origin_field = OriginField.new
         origin_field.field_name = field_name
         origin_field.origin_pic = origin_pic
         origin_field.data_type = data_type
         origin_field.position = position
         origin_field.origin_id = origin_id
         origin_field.width = width
         origin_field.current_user_id = current_user_id
    
         origin_field.save
    
         value_return = origin_field
        
        end
  
        value_return
  end

    def self.text_parser_generico(text_value, origin_id, current_user_id)
    
    return_value=nil
    
    unless (/^(\"[a-zA-Z0-9\_\-\<\>]*\"\,){3}(\"[a-zA-Z0-9\_\-\<\>]*\")$/.match(text_value).nil?)
      
      field_name=text_value.gsub('"', '').split(',').first
      
      origin_field = OriginField.new
            origin_field.field_name = field_name
            origin_field.origin_pic = "X(255)"
            origin_field.data_type = "alfanumerico"
            origin_field.position = 0
            origin_field.width = 0
            origin_field.origin_id = origin_id
            origin_field.current_user_id = current_user_id

            origin_field.save

            return_value = origin_field
      end

    return_value
  end

  def calculate_field_cd5_format
    if self.cd5_variable_number?
      case self.data_type
        when "Alfanumérico"
          self.cd5_format = "1"
        when "Numérico"
          self.cd5_format = "2"
        when "Compactado"
          self.cd5_format = "4"
        when "Numérico com vírgula"
          self.cd5_format = "2"
        when "Compactado com vírgula"
          self.cd5_format = "4"
        when "Binário Mainframe"
          self.cd5_format = "6"
        when "Data"
          self.cd5_format = "3"
        else
          self.cd5_format = nil
        end
    end
  end

  def calculate_field_cd5_format_desc
    if self.cd5_variable_number?
      case self.data_type
        when "Alfanumérico"
          self.cd5_format_desc = "character"
        when "Numérico", "Compactado", "Numérico com vírgula", "Compactado com vírgula", "Binário Mainframe"
          self.cd5_format_desc = "numeric"
        when "Data"
          self.cd5_format_desc = "data"
        else
          self.cd5_format_desc = nil
        end
    end
  end

  def calculate_field_default_value
    if self.cd5_variable_number?
      case self.data_type
        when "Alfanumérico"
          self.default_value = "_"
        when "Numérico", "Compactado", "Numérico com vírgula", "Compactado com vírgula", "Binário Mainframe", "Data"
          self.default_value = 0
        else
          self.default_value = nil
        end
    end
  end

  def calculate_field_cd5_origin_format_desc
    if self.cd5_variable_number?
      case self.data_type
        when "Alfanumérico"
          self.cd5_origin_format_desc = "character"
        when "Numérico", "Compactado", "Numérico com vírgula", "Compactado com vírgula", "Binário Mainframe"
          self.cd5_origin_format_desc = "numeric"
        when "Data"
          self.cd5_origin_format_desc = "data"
        else
          self.cd5_origin_format_desc = nil
        end
    end
  end

  def calculate_field_cd5_origin_format
    if self.cd5_variable_number?
      case self.data_type
        when "Alfanumérico"
          self.cd5_origin_format = "1"
        when "Numérico"
          self.cd5_origin_format = "2"
        when "Compactado"
          self.cd5_origin_format = "4"
        when "Numérico com vírgula"
          self.cd5_origin_format = "2"
        when "Compactado com vírgula"
          self.cd5_origin_format = "4"
        when "Binário Mainframe"
          self.cd5_origin_format = "6"
        when "Data"
          self.cd5_origin_format = "3"
        else
          self.cd5_origin_format = nil
        end
    end
  end

  def calculate_field_cd5_variable_name
    if self.cd5_variable_number?
      self.cd5_variable_name = "#{cd5_variable_number}#{field_name}"
    end
  end

  def calculate_field_generic_data_type
    case self.data_type
      when "Alfanumérico"
        self.generic_data_type = "texto"
      when "Numérico", "Compactado", "Numérico com vírgula", "Compactado com vírgula", "Binário Mainframe"
        self.generic_data_type = "numero"
      when "Data"
        self.generic_data_type = "data"
      else
        self.generic_data_type = nil
      end
  end

  def calculate_field_fmbase_format_type
    case self.data_type
      when "Alfanumérico"
        self.fmbase_format_type = "AN"
      when "Numérico", "Data", "Numérico com vírgula"
        self.fmbase_format_type = "ZD"
      when "Compactado", "Compactado com vírgula"
        self.fmbase_format_type = "PD"
      when "Binário Mainframe"
        self.fmbase_format_type = "BI"
      else
        self.fmbase_format_type = nil
    end
  end

end
