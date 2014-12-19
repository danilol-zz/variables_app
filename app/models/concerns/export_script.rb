module ExportScript

	def self.get_list_entits(script)
		return_value = nil
		reg = Regexp.new("<([A-Za-z]+)\\.\\[([A-Za-z\\ \\_]+)\\]>", Regexp::MULTILINE)
		lista = script.scan(reg)
		lista_ent = Hash.new
		lista.each do |item|
		    unless lista_ent.has_key?(item[0])
   		     	lista_ent[item[0]]=[item[1]]
   		    else
   		    	lista_ent[item[0]] << item[1]
    		end
		end

		unless lista_ent.empty?
			return_value = lista_ent
		end

		return_value

	end

	def self.translate_list(list)

		return_value=''
		test_hash_pass='S'
		test_entity='S'
		test_attr='S'
		#p "================================"
		#p "nova execução"
		#p list
		#p "-------------------------------"
		lista_ent = Hash.new

		#p "montagem do dicionario"
		#dicionario
		hash_transl = {
			"Campanha" => {
				"name_entity" => "Campaign" ,
				"class_entity" => Campaign ,
				"atribute_translate" => Hash.new
			} ,
			"Origem" => {
				"name_entity"=> "Origin" ,
				"class_entity" => Origin,
				"atribute_translate" => Hash.new
			} ,
			"CamposdeOrigem" => {
				"name_entity" => "OriginField" ,
				"class_entity" => OriginField,
				"atribute_translate" => Hash.new
			} ,
			"Processo" => {
				"name_entity" => "Processid" ,
				"class_entity" => Processid ,
				"atribute_translate" => Hash.new
			} ,
			"Tabela" => {
				"name_entity" => "Table" ,
				"class_entity" => Table ,
				"atribute_translate" => Hash.new
			} ,
			"Variavel" => {
				"name_entity" => "Variable" ,
				"class_entity" => Variable ,
				"atribute_translate" => Hash.new
			}
		}

		#p "------------------------------------"
		hash_transl.each_key do |entity|
			#p "entidade atual = #{entity}"
			hash_transl[entity]["class_entity"].attribute_names.each do |attribute_eng|
				#p "entidade ingles atual = #{attribute_eng}"
				attribute_br = hash_transl[entity]["class_entity"].human_attribute_name(attribute_eng)
				#p "entidade portugues atual = #{attribute_br}"
				hash_transl[entity]["atribute_translate"][attribute_br] = attribute_eng
			end
			#p "hash dicionario "
			#p hash_transl[entity]["atribute_translate"]
		end

		#p "dicionario: "

		#p hash_transl

		#p "--------------------------------------"
		#p "inicio da busca"
		unless list != nil &&  (list.instance_of? Hash) && list.size > 0
			test_hash_pass='N'
		else
			list.each_key do |ent_Br|
	   			#p "/-- Entidade portugues = #{ent_Br}"
	   			unless list[ent_Br] != nil && (list[ent_Br].instance_of? Array) &&
	   				list[ent_Br].size > 0 && hash_transl.has_key?(ent_Br)
	   				test_entity = 'N'
	   				#p "/--entidade nao existe ou com lista de campos incosistente"
	   			else
	   				ent_Eng=hash_transl[ent_Br]["name_entity"]
	   				#p "/--entidade ingles atual: #{ent_Eng}"
	   				lista_ent[ent_Eng] = []
	   				list[ent_Br].each do |attr_Br|
	   					#p "/-atributo portugues: #{attr_Br}"
	   					unless hash_transl[ent_Br]["atribute_translate"].has_key?(attr_Br)
	   						test_attr = 'N'
	   						#p "/-entidade nao encontrada"
	   					else
	   						attr_Eng = hash_transl[ent_Br]["atribute_translate"][attr_Br]
	   						 #p "/-atributo ingles: #{attr_Eng}"
	   						lista_ent[ent_Eng] << attr_Eng
	   					end
	   				end

	   			end
	   		end
		end

		#p "fim da busca"


		if test_hash_pass == 'S' && test_entity == 'S' && test_attr == 'S'
			#p lista_ent
			return_value = lista_ent
		else
			#p "retorno com falha: hash #{test_hash_pass} , entity #{test_entity}, attr #{test_attr}"
			return_value = nil
		end

		return_value
	end


#comentado para dar comiti, depois voltar
=begin

	def self.get_entits_by_sprint(sprint, entity)

		return_value=''

		#ind_valid_parms='S'

		#p "--- inicio ---"

		#p "sprint"
		#p sprint
		#p ! sprint.nil?
		#p sprint.class
		#p sprint.instance_of?(Fixnum)
		#if ( ! (sprint.nil?) ) &&  sprint.instance_of?(Fixnum)
		#	p sprint > 0
		#end

		#p "entity"
		#p entity
		#p entity.nil?
		#p entity.class
		#p entity.instance_of?(String)
		#if ( ! (entity.nil?) ) && entity.instance_of?(String)
		#	p entity.empty?
		#end



		unless ( ! (sprint.nil?) ) && ( ! (entity.nil?) ) &&
			       (sprint.instance_of?(Fixnum)) && (entity.instance_of?(String)) &&
			     ! (entity.empty?) && (sprint > 0 )
			#ind_valid_parms='N'
			return_value=nil
		else

			case entity
			when "Table"
				return_value = get_Table_by_sprint(sprint)
			when "Origin"
				return_value = get_Origin_by_sprint(sprint)
			when "OriginField"
				return_value = get_OriginField_by_sprint(sprint)
			when "Processid"
				return_value = get_Processid_by_sprint(sprint)
			when "Variable"
				return_value = get_Variable_by_sprint(sprint)
			else
				return_value=nil
			end
		end
		#p "ind_valid_parms = #{ind_valid_parms}"
		#p "--- fim ----"

		return_value

	end


	def self.get_Table_by_sprint(sprint)
		return_value = ''

		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		result = Table.where(updated_in_sprint: sprint)

		p sprint
		p result.class
		p result.size

		require 'pry' ; binding.pry;

		if result.size == 0
			return_value = nil
		else
			return_value = result
		end

		return_value
		#nil
	end

	def self.get_Origin_by_sprint(sprint)
	end

	def self.get_OriginField_by_sprint(sprint)
		nil
	end

	def self.get_Processid_by_sprint(sprint)
		nil
	end

	def self.get_Variable_by_sprint(sprint)
		nil
	end
=end





end
