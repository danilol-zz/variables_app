FactoryGirl.define do
  sequence :process_number do |n|
    n
  end

  sequence :process_mnemonic do |n|
    n
  end

  factory :processid do
    process_number { FactoryGirl.generate(:process_number) }
    mnemonic { FactoryGirl.generate(:process_mnemonic) }
    routine_name "MyString"
    var_table_name "MyString"
    conference_rule "MyString"
    acceptance_percent "MyString"
    keep_previous_work true
    counting_rule "MyString"
    notes "MyString"
    current_user_id 1
  end
end
