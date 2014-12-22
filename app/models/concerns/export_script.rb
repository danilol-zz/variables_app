module ExportScript

	def self.get_list_scritps
		return_value = make_script_list.keys
		#p return_value
		#p return_value.class
		return_value
	end

	def self.export_script_by_sprint(sprint,script_name)
		hash_scripts = make_script_list
		entity_master_br = hash_scripts[script_name]["entity_master_br"]
		script = hash_scripts[script_name]["script"]
		ind_group_related = hash_scripts[script_name]["ind_group_related"]
		condition = hash_scripts[script_name]["condition"]

		#p script_name
		#p sprint
		#p script
		#p entity_master_br
		#p ind_group_related
		#p condition


		array_script = generate_script_by_sprint(sprint, script, entity_master_br, ind_group_related, condition)
		return_value = "Resultado do Script : \n"
		return_value = return_value + "=========================================================================\n"
		array_script.each do |saida_script|
			return_value = return_value + saida_script + "\n"
			return_value = return_value + "----------------------------------------------------------------------\n"
		end
		return_value = return_value + "=========================================================================\n"
		return_value = return_value + "Fim do Scritp\n"

		#p return_value

		return_value
	end







#================================== metodos de processamento =========================================
	def self.generate_script_by_sprint(sprint, script, entity_master_br, ind_group_related, condition)
		return_value = ''

		ind_valid_relationship = 'S'
		ind_entit_reference = 'N'
		ind_group_funcion = 'S'

		list_entit = get_list_entits(script)
		list_condition = nil
		unless condition.nil?
			list_condition =  get_list_entits(condition)
		end
		#p "========================="
		#p "list_entit "
		#p list_entit

		#p "list_condition "
		#p list_condition
		dicionary = make_dictionary
		invert_entity_dicionary = Hash.new
		dicionary.keys.each do |key|
			invert_entity_dicionary[dicionary[key]["name_entity"]] = key
		end
		#p "========================="
		#p "dicionary"
		#p dicionary
		list_entit_translated = translate_list(list_entit,dicionary)
		list_condition_translated = nil
		#p "========================="
		#p "list_entit_translated "
		#p list_entit_translated
		unless condition.nil?
			list_condition_translated = translate_list(list_condition,dicionary)
			#p "list_condition_translated"
			#p list_condition_translated
		end 

		#hash_enti = {} 
		list_entit_master = []
		list_entit_reference_name =[]

		list_entit_translated.each_key do |entity_name_eng|
			#p dicionary[entity_master_br]["name_entity"] 
			#p entity_name_eng
			if dicionary[entity_master_br]["name_entity"] == entity_name_eng
				#p "vai add"
				if condition.nil?
					list_entit_master = get_entits_by_sprint(sprint,entity_name_eng,nil)
				else
					list_entit_master = get_entits_by_sprint(sprint,entity_name_eng,list_condition_translated[entity_name_eng])
				end
			else
				list_entit_reference_name = list_entit_reference_name + [entity_name_eng]
			end
		end
		if list_entit_reference_name.size > 0 
			ind_entit_reference = 'S'
		end
		#p "========================="
		#p "list_entit_master #{list_entit_master.size}"
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
				value_replace_master = ''
				if attr_master_Br.include? "@"
					value_replace_master = value_by_function(entity_master,attr_master_Br)
				else
					value_replace_master = entity_master[attr_master_eng]
				end
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
				#p "somente mestre"
				script_replace = script.gsub /\<[A-Za-z\ ]+\.\[.+?\]\>/ do |match|
	   				hash_repalce_master[match.to_s]
				end

				return_value = return_value + [script_replace]
			else
				#p "tem entidade relacionada"
				hash_repalce_related = {}
				list_entit_reference_name.each do |entity_reference_name_eng|
					#p "entidade relacionada atual #{entity_reference_name_eng}"
					array_entits_related = []
					if condition.nil?
						array_entits_related = get_entits_related(entity_master,entity_reference_name_eng,nil)
					else
						array_entits_related = get_entits_related(entity_master,entity_reference_name_eng,list_condition_translated[entity_reference_name_eng])
					end
					#p "quantidade de entidade encontradas: #{array_entits_related.size}"
					entity_reference_name_br = invert_entity_dicionary[entity_reference_name_eng]
					
					list_entit[entity_reference_name_br].each do |attr_reference_Br|
						#p "laco do campo #{attr_reference_Br}"
						key_replace_reference = "<#{entity_reference_name_br}.[#{attr_reference_Br}]>"
						#p "key attr #{key_replace_reference}"
						attr_reference_eng = dicionary[entity_reference_name_br]["atribute_translate"][attr_reference_Br]
					 	
					 	value_replace_reference =  ""
						#p "------ referncia ---------"
					 	

					 	if array_entits_related == nil
					 		ind_valid_relationship = "N"
					 	
					 	

					 	elsif ind_group_related && attr_reference_Br.include?("@")
					 		#p "a"
					 		value_replace_reference = value_by_function(array_entits_related,attr_reference_Br)
					 	
					 	elsif ind_group_related && ( ! attr_reference_Br.include?("@") )
					 		#p "b"
					 		ind_group_funcion = 'N'
					 	
					 	elsif ( ! ind_group_related ) && ( attr_reference_Br.include? ("@") )
					 		#p "c"
					 		value_replace_reference = value_by_function(array_entits_related,attr_reference_Br)
					 	
					 	else
					 		#p "d"
					 		value_replace_reference = array_entits_related[0][attr_reference_eng]
					 	
					 	end

					 	#p "------- referncia --------"
					 	#p "ind_group_related #{ind_group_related}"
					 	#p "attr_reference_Br.include?(@) #{attr_reference_Br.include?("@")}"


					 	hash_repalce_related[key_replace_reference] = value_replace_reference

					 end
				end
				#p "master #{hash_repalce_master.class.to_s}"
				#p "related #{hash_repalce_related.class.to_s}"
				hash_repalce_all = hash_repalce_master.merge hash_repalce_related

				script_replace = script.gsub /\<[A-Za-z\ ]+\.\[.+?\]\>/ do |match|
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
		#p ind_group_funcion

		if return_value.size == 0 || ind_valid_relationship == "N" || ind_group_funcion == 'N'
			return_value = nil
		end
		#p return_value
		return_value

	end






	def self.get_list_entits(script)
		return_value = ''
		
		#reg = Regexp.new("<([A-Za-z]+)\\.\\[([A-Za-z\\ \\_]+)\\]>", Regexp::MULTILINE)
		reg = Regexp.new("<([A-Za-z\\ ]+)\\.\\[(.+?)\\]>", Regexp::MULTILINE)
		
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
			test_attr = 'S'
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
	   					unless hash_transl[ent_Br]["atribute_translate"].has_key?(attr_Br.split(/\=/).first) ||
	   						attr_Br.include?("@")
	   						test_attr = 'N'
	   						#p "falhou"
	   						#p ent_Br
	   						#p attr_Br
	   						#p "/-entidade nao encontrada"
	   					else
	   						attr_Eng = hash_transl[ent_Br]["atribute_translate"][attr_Br.split(/\=/).first]
	   						 #p "/-atributo ingles: #{attr_Eng}"
	   						 if attr_Br.include? "=" 
	   						 	lista_ent[ent_Eng] << attr_Eng + "=" + attr_Br.split(/\=/).last
	   						 elsif attr_Br.include? "@"
	   						 	lista_ent[ent_Eng] << attr_Br
	   						 else
	   						 	lista_ent[ent_Eng] << attr_Eng
	   						 end
	   						
	   					end
	   				end
	   				#lista_ent[ent_Eng].uniq!
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



	def self.get_entits_by_sprint(sprint, entity,condition)

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
				return_value = get_Campaign_by_sprint(sprint,condition)
			when "Table"
				return_value = get_Table_by_sprint(sprint,condition)
			when "Origin"
				return_value = get_Origin_by_sprint(sprint,condition)
			when "OriginField"
				return_value = get_OriginField_by_sprint(sprint,condition)
			when "Processid"
				return_value = get_Processid_by_sprint(sprint,condition)
			when "Variable"
				return_value = get_Variable_by_sprint(sprint,condition)
			else
				return_value=nil
			end
		end
		#p "ind_valid_parms = #{ind_valid_parms}"
		#p "--- fim ----"

		return_value

	end



def self.get_entits_related(entity_ref, name_entity_to_find,condition)
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

		unless list_relationtship.size > 0 && list_relationtship.include?(list_entit_valid[name_entity_to_find])
			ind_valid_relationship = 'N'
		end
		
	end

	
	unless 	ind_valid_parms == 'S' && ind_valid_relationship == 'S'
		return_value = nil
	else
		cond = {}
		if condition.nil?
			cond = false
		else
			condition.each do |item|
				words=item.split(/\=/)
				cond[words[0]]=words[1]
			end
		end

	 	case list_entit_valid[name_entity_to_find]
	 	when "variables"
	 		return_value = entity_ref.variables.where(cond).to_a
	 	when "origin"
	 		return_value = [entity_ref.origin]
	 	when "origin_fields"
	 		return_value = entity_ref.origin_fields.where(cond).to_a
	 	when "campaigns"
	 		return_value = entity_ref.campaigns.where(cond).to_a
	 	when "processids"
	 		return_value = entity_ref.processids.where(cond).to_a
	 	when "tables"
	 		return_value = entity_ref.tables.where(cond).to_a
	 	else
	 		return_value = nil
	 	end
	 			
	end 
	
	#p "==== return === #{return_value.size}"
	#p return_value
	return_value
end


	def self.get_Campaign_by_sprint(sprint,condition)
		return_value = ''
		
		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		cond = {}
		if condition.nil?
			cond = false
		else
			condition.each do |item|
				words=item.split(/\=/)
				cond[words[0]]=words[1]
			end
		end

		result = Campaign.where(updated_in_sprint: sprint).where(cond).to_a
		
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

	def self.get_Table_by_sprint(sprint,condition)
		return_value = ''

		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		cond = {}
		if condition.nil?
			cond = false
		else
			condition.each do |item|
				words=item.split(/\=/)
				cond[words[0]]=words[1]
			end
		end
		result = Table.where(updated_in_sprint: sprint).where(cond).to_a
		
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

	def self.get_Origin_by_sprint(sprint,condition)
		return_value = ''
		
		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		cond = {}
		if condition.nil?
			cond = false
		else
			condition.each do |item|
				words=item.split(/\=/)
				cond[words[0]]=words[1]
			end
		end		

		result = Origin.where(updated_in_sprint: sprint).where(cond).to_a
		
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

	def self.get_OriginField_by_sprint(sprint,condition)
		return_value = ''
		
		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		
		cond = {}
		if condition.nil?
			cond = false
		else
			condition.each do |item|
				words=item.split(/\=/)
				cond[words[0]]=words[1]
			end
		end		


		result = []
		Origin.where(updated_in_sprint: sprint).to_a.each do |org| 
			result = result + org.origin_fields.where(cond).to_a
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

	def self.get_Processid_by_sprint(sprint,condition)
		return_value = ''
		
		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		cond = {}
		if condition.nil?
			cond = false
		else
			condition.each do |item|
				words=item.split(/\=/)
				cond[words[0]]=words[1]
			end
		end	


		result = []
		Variable.where(updated_in_sprint: sprint).to_a.each do |pro| 
			result = result + pro.processids.where(cond).to_a
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

	def self.get_Variable_by_sprint(sprint,condition)
		return_value = ''
		
		#concect = Table.connection
		#p concect.class
		#p concect
		#p Table.connected?
		#result = Table.select { |m| m.updated_in_sprint == sprint }
		cond = {}
		if condition.nil?
			cond = false
		else
			condition.each do |item|
				words=item.split(/\=/)
				cond[words[0]]=words[1]
			end
		end	


		result = Variable.where(updated_in_sprint: sprint).where(cond).to_a
		
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
			"Campos de Origem" => {
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

	## script_list
	def self.make_script_list
		#sprint, script, entity_master_br, ind_group_related, condition
		hash_scripts = {
			"Scritp Unix Rotina PV" => 	{
				"entity_master_br" => "Processo" ,
				"ind_group_related" => false ,
				"condition" => nil ,
				"script" => "<>"
			} ,
			"Scritp Unix Rotina PT" => {
				"entity_master_br" => "Tabela" ,
				"ind_group_related" => false ,
				"condition" => "<Tabela.[Tipo=seleção]>" ,
				"script" => "<>"
			} ,
			"Script Unix Rotina PS" => {
				"entity_master_br" => "Tabela" ,
				"ind_group_related" => false ,
				"condition" => "<Tabela.[Tipo=seleção]>" ,
				"script" => "<>"

			} ,
			"Script Unix Ziptrans" => {
				"entity_master_br" => "Tabela" ,
				"ind_group_related" => false ,
				"condition" => "<Tabela.[Tipo=seleção]>" ,
				"script" => "<>"

			} ,
			"Scritp Unix Data Stage Espelho Rotina PE" => {
				"entity_master_br" => "Tabela" ,
				"ind_group_related" => false ,
				"condition" => "<Tabela.[Tipo=seleção]>" ,
				"script" => "<>"
			} ,
			"Scritp Hive Tabela ORG" => {
				"entity_master_br" => "Origem" ,
				"ind_group_related" => true ,
				"condition" => "<Campos de Origem.[Vai usar ?=SIM]>" ,
				"script" => "<>"
			} ,
			"Script Hive Query PV Vazia" => {
				"entity_master_br" => "Processo" ,
				"ind_group_related" => true ,
				"condition" => nil ,
				"script" => "<>"
			} ,
			"Scritp MySql Cadastro de Processo de Arquivo" => {
				"entity_master_br" => "Origem" ,
				"ind_group_related" => false ,
				"condition" => nil ,
				"script" => "<>"
			} ,
			"Script MySql Cadastro de Arquivo" => {
				"entity_master_br" => "Origem" ,
				"ind_group_related" => false ,
				"condition" => nil ,
				"script" => "insert into controle_bigdata.tah6_pro values (“CD5P<Origem.[Mnemônico]>”,”<Origem.[Nome da base/arquivo]>”,”<Origem.[@periodicidade_origem_mysql]>”,”2014-12-23”);"
			} ,
			"Script MySql Cadastro Qualidade de Arquivo" => {
				"entity_master_br" => "Origem" ,
				"ind_group_related" => false ,
				"condition" => nil ,
				"script" => "<>"
			} ,
			"Script MySql Cadastro Regra de Qualidade de Arquivo" => {
				"entity_master_br" => "Origem" ,
				"ind_group_related" => false ,
				"condition" => nil ,
				"script" => "<>"
			} ,
			"Script MySql Cadastro de Processo de Calculo de Variavel - Rotina PV" => {
				"entity_master_br" => "Processo" ,
				"ind_group_related" => true ,
				"condition" => nil ,
				"script" => "<>"
			} ,
			"Script MySql Cadastro de Processo de Calculo de Tabela - Rotina PT" => {
				"entity_master_br" => "Tabela" ,
				"ind_group_related" => true ,
				"condition" => "<Tabela.[Tipo=seleção]>" ,
				"script" => "<>"
			} ,
			"Integração CD5 Cadastro de Campo de Entrada" => {
				"entity_master_br" => "Campos de Origem" ,
				"ind_group_related" => false ,
				"condition" => "<Campos de Origem.[Vai usar ?=SIM]>" ,
				"script" => "<>"
			} ,
			"Integração CD5 Cadastro de Campo de Saida" => {
				"entity_master_br" => "Campos de Origem" ,
				"ind_group_related" => false ,
				"condition" => "<Campos de Origem.[Vai usar ?=SIM]>" ,
				"script" => "<>"
			} ,
			"Smap Rotina Mainframe Extrator" => {
				"entity_master_br" => "Origem" ,
				"ind_group_related" => false ,
				"condition" => nil ,
				"script" => "<>"
			} ,
			"Smap Rotina Mainframe Roteador" => {
				"entity_master_br" => "Origem" ,
				"ind_group_related" => false ,
				"condition" => nil ,
				"script" => "<>"
			} ,
			"Smap Rotina PV" => {
				"entity_master_br" => "Processo" ,
				"ind_group_related" => true ,
				"condition" => nil ,
				"script" => "<>"
			} ,
			"Smap Rotina PT" => {
				"entity_master_br" => "Tabela" , 
				"ind_group_related" => true ,
				"condition" => nil ,
				"script" => "<>"
			} ,
			"Smap Rotina PS" => {
				"entity_master_br" => "Tabela" , 
				"ind_group_related" => true ,
				"condition" => nil ,
				"script" => "<>"	
			} ,
			"Smap Rotina Ziptrans" => {
				"entity_master_br" => "Tabela" , 
				"ind_group_related" => true ,
				"condition" => nil ,
				"script" => "<>"
			} ,
			"Smap Rotina Data Stage Espelho" => {
				"entity_master_br" => "Tabela" , 
				"ind_group_related" => true ,
				"condition" => nil ,
				"script" => "<>"
			} ,
			"Smap Rotina Data Stage Definitivo" => {
				"entity_master_br" => "Tabela" , 
				"ind_group_related" => true ,
				"condition" => nil ,
				"script" => "<>"
			}
		}
		hash_scripts
	end



	def self.value_by_function(entity,attr_master_Br)

		return_value = ''

		case attr_master_Br
		when "@nome_data_stage_espelho"
			return_value = nome_data_stage(entity, "espelho" )
		when "@nome_data_stage_definitivo"
			return_value = nome_data_stage(entity, "definitivo" )
		when "@periodicidade_origem_mysql"
			return_value = periodicidade(entity,"mysql")
		when "@periodicidade_origem_particao"
			return_value = periodicidade(entity,"particao")
		when "@periodicidade_origem_smap"
			return_value = periodicidade(entity,"smap")
		when "@lista_de_campos"
			return_value = lista_de_campos(entity)
		when "@expressao_regular"
			return_value = expressao_regular(entity)
		when "@tamanho_expandido"
			return_value = tamanho_expandido(entity)

		when "@chave_hive"
			return_value = chave_hive(entity)
 
		when "@campos_modelo"
			return_value = campos_modelo(entity)
			
		else
			return_value = nil
		end

		return_value

	end


	def self.nome_data_stage(table, type)
		
		return_value = ''
		

		unless ( ! table.nil? ) && ( ! table.nil? ) && table.instance_of?(Table) && 
			( type == "espelho" || type == "definitivo" )
			return_value = nil
		else
			#mirror_table_number
			#mirror_physical_table_name
			number_table = nil
			name_table = nil
			slice_type = nil
			end_type = nil

			if type == "espelho"
				slice_type = "_ESPL_"
				end_type = "_esp"
				number_table = table.mirror_table_number.to_s
				name_table = table.mirror_physical_table_name.to_s
			else
				slice_type = "_"
				end_type = "_def"
				number_table = table.final_table_number.to_s
				name_table = table.final_physical_table_name.to_s
			end


			slice_part = "TBCD5" + number_table + slice_type
			part_table_part =  name_table
			part_table_part.slice!(slice_part)
			
			return_value = "CD5_" + number_table + "_carga_tabela_" + part_table_part.to_s.downcase + end_type


		end

		return_value
	end

	def self.periodicidade(entity,type)
		return_value = ''

		unless ( ! entity.nil? ) && ( ! type.nil? ) && 
			( entity.instance_of?(Origin) || entity.instance_of?(Table) || entity.instance_of?(Processid) )&& 
			type.instance_of?(String) &&
			(type == "mysql" || type == "particao" || type == "smap")
			return_value = nil 
			
		else
			if 	entity.instance_of?(Origin)
				if type == "smap"
					return_value = entity.periodicity
				elsif entity.periodicity == "mensal" && type == "mysql"
					return_value = "M"
				elsif entity.periodicity == "mensal" && type == "particao"
					return_value = "anomes"
				elsif type == "particao"
					return_value = "anomesdia"
				else
					return_value = "D"
				end
			else
				priority = {
					"diária" => 1 ,
					"semanal" => 2 ,
					"quinzenal" => 3 ,
					"mensal"  => 4 ,
					"anual" => 5 ,
					"exporádica" => 6 , 
					"outro" => 7
				}

				#p "============="
				unless entity.variables.to_a.size > 0
					return_value = nil 
				else
					return_value = "outro"
					entity.variables.to_a.each do |variable|

						if priority[return_value] > priority[variable.sas_update_periodicity]
							#p "trocou"
							return_value = variable.sas_update_periodicity
						end
					end
				end
					
			end		
		end
		return_value

	end

	def self.lista_de_campos(array_orign_fields)
		return_value = ''
		
		unless ( ! array_orign_fields.nil? ) && array_orign_fields.instance_of?(Array) && array_orign_fields.size > 0   && array_orign_fields[0].instance_of?(OriginField)
			return_value = nil
		else
			#p "array_orign_fields #{array_orign_fields}"
			#p "class = #{array_orign_fields.class}"
			array_orign_fields.each do |origin_field|
				return_value = return_value + origin_field.field_name + " string , \n"
			end
			
			return_value = return_value + "FILLER string "
		end


		return_value
	end

	def self.lista_de_rotinas_sucessoras(array_variable)
		return_value = ''
		
		unless ( ! array_variable.nil? ) && array_variable.instance_of?(Array) && array_variable.size > 0   && array_variable[0].instance_of?(Variable)
			return_value = nil
		else
			#p "array_orign_fields #{array_orign_fields}"
			#p "class = #{array_orign_fields.class}"
			return_value = ''
			array_variable.each do |variable|
				variable.tables.where( type: "seleção" ).to_a.each do |table|
					return_value = return_value + table.big_data_routine_name + " ;"
				end
			end
			
			return_value = return_value 
		end


		return_value
	end

	def self.tamanho_expandido(origin_field)
		
		return_value = ''

		unless ( ! origin_field.nil? ) && ( origin_field.instance_of?(OriginField))
			return_value = nil
		else
			if origin_field.fmbase_format_datyp == "AN" || origin_field.fmbase_format_datyp == "BI"
				return_value = origin_field.width.to_s
			else
				
				vlr_signal = 0
				vlr_comma = 0
				
				if origin_field.has_signal == "SIM"
					vlr_signal = 1
				end

				if origin_field.data_type == "numerico com virgula" || origin_field.data_type == "compactado com virgula" 
					vlr_comma = 1
				end
				#p origin_field.field_name
				#p origin_field.data_type
				#p vlr_signal
				#p vlr_comma
				result = origin_field.width + vlr_comma + vlr_signal

				return_value = result.to_s

			end
					
		end

		return_value
	end

	def self.expressao_regular(array_orign_fields)
		return_value = ''
		
		unless ( ! array_orign_fields.nil? ) && array_orign_fields.instance_of?(Array) && array_orign_fields.size > 0   && array_orign_fields[0].instance_of?(OriginField)
			return_value = nil
		else
			#p "array_orign_fields #{array_orign_fields}"
			#p "class = #{array_orign_fields.class}"
			return_value = ""
			array_orign_fields.each do |origin_field|
				if  origin_field.will_use == "SIM"
					return_value = return_value + "(.{0," + tamanho_expandido(origin_field) + "})"
				end
			end
			
			return_value = return_value + "(.{0,1343})"
		end


		return_value	
	end

	def self.chave_hive(processid)
		return_value = ''

		#p "============="
		#p processid.class
		#p processid.variables.to_a.size
		#p processid.variables.to_a[0].tables.where( type: "seleção").to_a
		#p processid.variables.to_a[0].tables.where( type: "seleção").to_a.size

		unless ( ! processid.nil? ) &&
			processid.instance_of?(Processid) &&
			processid.variables.to_a.size > 0 &&
			processid.variables.to_a[0].tables.where( table_type: "seleção").to_a.size > 0
			return_value = nil
		else
			return_value = processid.variables.to_a[0].tables.where( table_type: "seleção").to_a[0].key_fields_hive_script.to_s
			
		end

		#p return_value
		#p "---------------------"
		return_value
	end

	def self.campos_modelo(processid)
		return_value = ''

		unless ( ! processid.nil? ) &&
			processid.instance_of?(Processid) &&
			processid.variables.to_a.size > 0
			return_value = nil
		else
			
			processid.variables.to_a.each do |variable|
				if variable.model_field_name == processid.variables.to_a.last
					return_value + variable.model_field_name + " string \n"
				else
					return_value = return_value + variable.model_field_name + " string , \n"
				end
			end
			
		end
		return_value

	end

	def self.posicao_saida(origin_field)
		return_value = ''
		
		#p origin_field
		#p origin_field.class
		#p origin_field.instance_of?(OriginField)
		#p origin_field.will_use == "SIM"

		unless ( ! origin_field.nil?) &&
			origin_field.instance_of?(OriginField) &&
			origin_field.will_use == "SIM"
			return_value = nil
		 else
		 	#p "valido "
		 	return_value = 0
		 	
		 	origin_field.origin.origin_fields.where(will_use: "SIM").to_a.each do |org_atu|
		 		if org_atu.cd5_output_order < origin_field.cd5_output_order
		 			return_value = return_value + tamanho_expandido(org_atu).to_i
		 		end
		 	end
		 	return_value = return_value + 1
		 	return_value = return_value.to_s
		 end 
		 #p "tamanho saida: #{return_value}"
		 return_value
	end

end
		





