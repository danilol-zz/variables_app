FactoryGirl.define do
  factory :variable do
    name "MyString"
    sas_variable_def "MyString"
    sas_variable_domain "MyString"
    created_in_sprint 1
    updated_in_sprint 1
    sas_data_model_status "Ok"
    drs_bi_diagram_name "MyString"
    drs_variable_status "Ok"
    room_1_notes "MyText"
    width 1
    decimal 1
    default_value "MyString"
    room_2_notes "MyText"
    model_field_name "MyString"
    data_type "Qtd"
    sas_variable_rule_def "MyString"
    sas_update_periodicity "semanal"
    domain_type "fixo"
    variable_type "calculado"
    owner "MyString"
    status "sala1"
    tables []
    origin_fields []
    current_user_id 1
  end
end
