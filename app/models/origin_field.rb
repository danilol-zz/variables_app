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
  before_save :calculate_origin_file_field_name

  belongs_to :origin
  has_and_belongs_to_many :variables

  validates :field_name, presence: true, if: :current_user_is_room1?
  validates :data_type, presence: true, inclusion: { in: Constants::DATA_TYPES }, if: :current_user_is_room1?
  validates :decimal, presence: true, if: lambda { current_user_is_room1? && data_type_is_numeric? }
  validates :mask, length: { maximum: 30 }, if: :current_user_is_room1?
  validates :position, presence: true, if: :current_user_is_room1?
  validates_inclusion_of :is_key, in: [true, false], if: :current_user_is_room1?
  validates :width, presence: true, if: :current_user_is_room1?
  validates_inclusion_of :will_use, in: [true, false], if: lambda { current_user_is_room1? && data_type_is_numeric? }
  validates_inclusion_of :has_signal, in: [true, false], if: lambda { current_user_is_room1? && data_type_is_numeric? }

  validates :cd5_variable_number, presence: true, if: lambda { current_user_is_room2? && !self.is_key && self.will_use }
  validates :cd5_variable_number, uniqueness: true, if: :current_user_is_room2?
  validates :cd5_output_order, presence: true, if: lambda { current_user_is_room2? && self.cd5_variable_number }

  def calculate_origin_file_field_name
    unless self.origin.nil?
      self.origin_file_field_name = self.origin.file_name + ':' + field_name
    end
  end

  def self.text_parser(origin_type, text_value, origin_id, current_user_id)
    text_value = text_value.to_s.gsub(/\n/, '').gsub(/\r/, '')

    return text_parser_mainframe(text_value, origin_id, current_user_id) if "mainframe" == origin_type
    return text_parser_generico(text_value, origin_id, current_user_id)  if ["hadoop", "outro"].include? origin_type
  end

  def self.text_parser_mainframe(text_value, origin_id, current_user_id)
    captura = /(.{0,5})(.{0,40})(.{0,10})(.{0,8})(.{0,6})(.{0,6})(.{0,6})/.match(text_value)

    unless ( captura[7].empty? ) || (/^[0-9]+\ ([A-Za-z0-9]+)[A-Za-z0-9\ ]*$/.match(captura[2].strip).nil? )
      field_name = /^[0-9]+\ ([A-Za-z0-9]+)[A-Za-z0-9\ ]*$/.match(captura[2].strip)[1]
      origin_pic = captura[3].strip
      fmbase_value = captura[4].strip
      position = captura[5].strip
      width = captura[7].strip

      origin_pic = "X(#{width})" if origin_pic.empty?

      ind_comma = false

      ind_comma = true unless /[V]/.match(origin_pic).nil?

      if ind_comma
        if fmbase_value == "ZD"
          data_type = "Numérico com vírgula"
        elsif fmbase_value == "PD"
          data_type = "Compactado com Vírgula"
        else
          data_type = ""
        end
      else
        if fmbase_value ==  "ZD"
          data_type = "Numérico"
        elsif fmbase_value == "PD"
          data_type = "Compactado"
        elsif fmbase_value == "BI"
          data_type = "Binário Mainframe"
        elsif fmbase_value == "AN"
          data_type = "Alfanumérico"
        else
          data_type = ""
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
        origin_field.decimal = 0
        origin_field.will_use = true
        origin_field.is_key = true
        origin_field.has_signal = true

        origin_field.save
        value_return = origin_field

    end

    value_return
  end

  def self.text_parser_generico(text_value, origin_id, current_user_id)
    return_value=nil
    unless (/^(\"[a-zA-Z0-9\_\-\<\>]*\"\,){3}(\"[a-zA-Z0-9\_\-\<\>]*\")$/.match(text_value).nil?)
      field_name                    = text_value.gsub('"', '').split(',').first
      origin_field                  = OriginField.new
      origin_field.field_name       = field_name
      origin_field.origin_pic       = "X(255)"
      origin_field.data_type        = "Alfanumérico"
      origin_field.is_key           = false
      origin_field.will_use         = false
      origin_field.has_signal       = false
      origin_field.position         = 0
      origin_field.width            = 0
      origin_field.origin_id        = origin_id
      origin_field.current_user_id  = current_user_id
      origin_field.save
      return_value                  = origin_field
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
        when "Compactado com Vírgula"
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
        when "Numérico", "Compactado", "Numérico com vírgula", "Compactado com Vírgula", "Binário Mainframe"
          self.cd5_format_desc = "numeric"
        when "Data"
          self.cd5_format_desc = "Data"
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
        when "Numérico", "Compactado", "Numérico com vírgula", "Compactado com Vírgula", "Binário Mainframe", "Data"
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
        when "Numérico", "Compactado", "Numérico com vírgula", "Compactado com Vírgula", "Binário Mainframe"
          self.cd5_origin_format_desc = "numeric"
        when "Data"
          self.cd5_origin_format_desc = "Data"
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
        when "Compactado com Vírgula"
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
      when "Numérico", "Compactado", "Numérico com vírgula", "Compactado com Vírgula", "Binário Mainframe"
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
      when "Compactado", "Compactado com Vírgula"
        self.fmbase_format_type = "PD"
      when "Binário Mainframe"
        self.fmbase_format_type = "BI"
      else
        self.fmbase_format_type = nil
    end
  end

  private

  def data_type_is_numeric?
    !['Data', 'Alfanumérico'].include?(self.data_type)
  end
end
