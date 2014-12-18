FactoryGirl.define do

  sequence :mnemonic do |n|
    n
  end

  sequence :cd5_portal_origin_code do |n|
    n
  end

  sequence :cd5_portal_destination_code do |n|
    n
  end

  factory :origin do
    file_name "MyString"
    file_description "MyString"
    created_in_sprint 1
    updated_in_sprint 1
    abbreviation "ABV"
    base_type "MyString"
    book_mainframe "MyString"
    periodicity "MyString"
    periodicity_details "MyString"
    data_retention_type "MyString"
    extractor_file_type "MyString"
    room_1_notes "MyText"
    mnemonic { FactoryGirl.generate(:mnemonic) }
    cd5_portal_origin_code { FactoryGirl.generate(:cd5_portal_origin_code) }
    cd5_portal_origin_name "MyString"
    cd5_portal_destination_code { FactoryGirl.generate(:cd5_portal_destination_code) }
    cd5_portal_destination_name "MyString"
    hive_table_name "MyString"
    mainframe_storage_type "MyString"
    room_2_notes "MyText"
    dmt_advice "MyString"
    dmt_classification "MyString"
    status "sala1"
    current_user_id 1
  end
end

