module ExportScript

	def self.generate_script_by_sprint(sprint, script, entity_master_br)
		return_value = ''

		ind_valid_relationship = 'S'
		ind_entit_reference = 'N'

		list_entit = get_list_entits(script)
		#p "========================="
		#p "list_entit "
		#p list_entit
		dicionary = make_dictionary
		invert_entity_dicionary = Hash.new
		dicionary.keys.each do |key|
			invert_entity_dicionary[dicionary[key]["name_entity"]] = key
		end
		#p "========================="
		#p "dicionary"
		#p dicionary
		list_entit_translated = translate_list(list_entit,dicionary)
		#p "========================="
		#p "list_entit_translated "
		#p list_entit_translated
		hash_enti = {} 
		list_entit_master = []
		list_entit_reference_name =[]

		list_entit_translated.each_key do |entity_name_eng|
			#p dicionary[entity_master_br]["name_entity"] 
			#p entity_name_eng
			if dicionary[entity_master_br]["name_entity"] == entity_name_eng
				#p "vai add"
				list_entit_master = get_entits_by_sprint(sprint,entity_name_eng)
			else
				list_entit_reference_name = list_entit_reference_name + [entity_name_eng]
			end
		end
		if list_entit_reference_name.size > 0 
			ind_entit_reference = 'S'
		end
		#p "========================="
		#p "list_entit_master"
		#p list_entit_master
		hash_repalce_master = {}
		return_value = []
		list_entit_master.each do |entity_master|
			#p "laco 1 #{entity_master}"
			hash_repalce_master = {}
			
			list_entit[entity_master_br].each do |attr_master_Br|
				#p "laco 2 #{attr_master_Br}"
				key_replace_master = "<#{entity_master_br}.[#{attr_master_Br}]>"
				#p "key_replace_master #{key_replace_master}"
				ent_Eng = dicionary[entity_master_br]["name_entity"]
				#p "ent_Eng #{ent_Eng}"
				attr_master_eng = dicionary[entity_master_br]["atribute_translate"][attr_master_Br]
				#p "attr_master_eng #{attr_master_eng}"
				value_replace_master = entity_master[attr_master_eng]
				#p "value_replace_master #{value_replace_master}"
				hash_repalce_master[key_replace_master] = value_replace_master
			end

				#script_replace = script.gsub /\<[A-Za-z]+\.\[.+?\]\>/ do |match|
	   			#	hash_repalce_master[match.to_s]
				#end

				#return_value = return_value + [script_replace]

			#p "========================="
			#p "hash_repalce"
			#p hash_repalce_master

			if ind_entit_reference == 'N'
				script_replace = script.gsub /\<[A-Za-z]+\.\[.+?\]\>/ do |match|
	   				hash_repalce_master[match.to_s]
				end

				return_value = return_value + [script_replace]

			else

				list_entit_reference_name.each do |entity_reference_name_eng|
					hash_repalce_related = {}
					entity_reference_name_br = invert_entity_dicionary[entity_reference_name_eng]
					# => list_entit_reference_name.each do |
					list_entit[entity_reference_name_br].each do |attr_reference_Br|
						key_replace_reference = "<#{entity_reference_name_br}.[#{attr_reference_Br}]>"
						attr_reference_eng = dicionary[entity_reference_name_br]["atribute_translate"][attr_reference_Br]
					 	ret = get_entits_related(entity_master,entity_reference_name_eng)
					 	value_replace_reference =""
					 	if ret != nil
					 		value_replace_reference = ret[0][attr_reference_eng]
					 	else
					 		ind_valid_relationship = "N"
					 	end

					 	hash_repalce_related[key_replace_reference] = value_replace_reference

					 end
				end
### - COLOCAR ARQUI O BEGIN

				hash_repalce_all = hash_repalce_master + hash_repalce_related


				script_replace = script.gsub /\<[A-Za-z]+\.\[.+?\]\>/ do |match|
   			 		hash_repalce_all[match.to_s]
				end

				return_value = return_value + [script_replace]
				
			end

		end

		#p "====result_value==="
		#p return_value
		#p return_value.class
		#p return_value.size
		#p ind_valid_relationship

		if return_value.size == 0 || ind_valid_relationship == "N"
			return_value = nil
		end

		return_value

	end






	def self.get_list_entits(script)
		return_value = ''
		
		#reg = Regexp.new("<([A-Za-z]+)\\.\\[([A-Za-z\\ \\_]+)\\]>", Regexp::MULTILINE)
		reg = Regexp.new("<([A-Za-z]+)\\.\\[(.+?)\\]>", Regexp::MULTILINE)
		
		lista = script.scan(reg)
		lista_ent = Hash.new
		
		lista.each do |item| 
		    unless lista_ent.has_key?(item[0]) 
   		     	#lista_ea_ent.has_key?(item[0]) 
   		     	lista_ent[item[0]]=[item[1]]
   		    else
   		    	lista_ent[item[0]] << item[1]
   		    	lista_ent[item[0]].uniq!
    		end
		end

		unless lista_ent.empty?
			return_value = lista_ent
		else
			return_value = nil
		end

		return_value

	end




	def self.translate_list(list, hash_transl)
		
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
			when "Campaign"
				return_value = get_Campaign_by_sprint(sprint)
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



def self.get_entits_related(entity_ref, name_entity_to_find)
	# origem - campo de origem
	# variavel - campo de origem
	# campanha - variavel
	# tabela - variavel
	# processo - variavel

	#:belongs_to
	#:has_and_belongs_to_many
	#:has_many

	list_entit_valid = 
	{	"Variable" => "variables" ,
		"Origin" => "origin" ,
		"OriginField" => "origin_fields" ,
		"Campaign" => "campaigns" ,
		"Processid" => "processids" ,
		"Table" => "tables"
	}

	return_value = ''

	ind_valid_parms = 'S'
	ind_valid_relationship = 'S'

	list_relationtship = []

		#p "entity_ref: #{entity_ref}"
		#p "name_entity_to_find: #{name_entity_to_find}"
		#p "#{entity_ref.class}"
		#p "#{list_entit_valid.include?(entity_ref.class.to_s)}"
		#p "#{list_entit_valid.include?(name_entity_to_find)}"

	unless entity_ref != nil && name_entity_to_find != nil &&
		list_entit_valid.has_key?(entity_ref.class.to_s) &&
		list_entit_valid.has_key?(name_entity_to_find)
		#p "invalid"

		ind_valid_parms = 'N'

	else
		#p "passou parm"
		#p "====belong===="
		#p "refletion: #{entity_ref.class.reflect_on_all_associations(:belongs_to)}"
		#p "===has many and belong====="
		#p "refletion: #{entity_ref.class.reflect_on_all_associations(:has_and_belongs_to_many)}"
		#p "===has many====="
		#p "refletion: #{entity_ref.class.reflect_on_all_associations(:has_many)}"

		entity_ref.class.reflect_on_all_associations(:belongs_to).each do |entity|
			list_relationtship = list_relationtship + [entity.name.to_s]

		end
		
		entity_ref.class.reflect_on_all_associations(:has_and_belongs_to_many).each do |entity|
			list_relationtship = list_relationtship + [entity.name.to_s]

		end
		
		entity_ref.class.reflect_on_all_associations(:has_many).each do |entity|
			list_relationtship = list_relationtship + [entity.name.to_s]

		end

		list_relationtship.uniq!

		#p " lista de relacionamento: #{list_relationtship}"
		#p " lista de relacionamento: #{list_relationtship[0]}"
		#p "list_relationtship.size #{list_relationtship.size}"

		unless list_relationtship.size > 0
			ind_valid_relationship = 'N'
		end
		
	end

	
	unless 	ind_valid_parms == 'S' && ind_valid_relationship == 'S'
		return_value = nil
	else
	 	case list_entit_valid[name_entity_to_find]
	 	when "variables"
	 		return_value = entity_ref.variables.to_a
	 	when "origin"
	 		return_value = [entity_ref.origin]
	 	when "origin_fields"
	 		return_value = entity_ref.origin_fields.to_a
	 	when "campaigns"
	 		return_value = entity_ref.campaigns.to_a
	 	when "processids"
	 		return_value = entity_ref.processids.to_a
	 	when "tables"
	 		return_value = entity_ref.tables.to_a
	 	else
	 		return_value = nil
	 	end
	 			
	end 
	#p "==== return === #{return_value.size}"
	#p return_value
	return_value
end


	def self.get_Campaign_by_sprint(sprint)
		return_value = ''
		
		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		result = Campaign.where(updated_in_sprint: sprint).to_a
		
		#p sprint
		#p result.class
		#p result.size

		#require 'pry' ; binding.pry;

		if result.size == 0
			return_value = nil
		else
			return_value = result
		end
		
		return_value
	end

	def self.get_Table_by_sprint(sprint)
		return_value = ''
		
		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		result = Table.where(updated_in_sprint: sprint).to_a
		
		#p sprint
		#p result.class
		#p result.size

		#require 'pry' ; binding.pry;

		if result.size == 0
			return_value = nil
		else
			return_value = result
		end
		
		return_value
		#nil
	end

	def self.get_Origin_by_sprint(sprint)
		return_value = ''
		
		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		result = Origin.where(updated_in_sprint: sprint).to_a
		
		#p sprint
		#p result.class
		#p result.size
		#p result

		#require 'pry' ; binding.pry;

		if result.size == 0
			return_value = nil
		else
			return_value = result
		end
		
		return_value
	end

	def self.get_OriginField_by_sprint(sprint)
		return_value = ''
		
		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		result = []
		Origin.where(updated_in_sprint: sprint).to_a.each do |org| 
			result = result + org.origin_fields.to_a
		end

		#p sprint
		#p result.class
		#p result[0].class
		#p result.size
		#p result

		#require 'pry' ; binding.pry;

		if result.size == 0
			return_value = nil
		else
			return_value = result
		end
		
		return_value
	end

	def self.get_Processid_by_sprint(sprint)
		return_value = ''
		
		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		result = []
		Variable.where(updated_in_sprint: sprint).to_a.each do |pro| 
			result = result + pro.processids.to_a
		end

		#p sprint
		#p result.class
		#p result[0].class
		#p result.size
		#p result

		#require 'pry' ; binding.pry;

		if result.size == 0
			return_value = nil
		else
			return_value = result
		end
		
		return_value
	end

	def self.get_Variable_by_sprint(sprint)
		return_value = ''
		
		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		result = Variable.where(updated_in_sprint: sprint).to_a
		
		#p sprint
		#p result.class
		#p result.size
		#p result

		#require 'pry' ; binding.pry;

		if result.size == 0
			return_value = nil
		else
			return_value = result
		end
		
		return_value
	end


	def self.make_dictionary
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
				#pair_replace = "<#{entity}.[#{attribute_br}]>"
				hash_transl[entity]["atribute_translate"][attribute_br] = attribute_eng
			end
			#p "hash dicionario "
			#p hash_transl[entity]["atribute_translate"]
		end

		hash_transl
	end
end
		




