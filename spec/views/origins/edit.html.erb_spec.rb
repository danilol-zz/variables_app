require 'rails_helper'

RSpec.describe "origins/edit", :type => :view do
  before(:each) do
    @origin = assign(:origin, Origin.create!(
      :file_name => "MyString",
      :file_description => "MyString",
      :created_in_sprint => 1,
      :updated_in_sprint => 1,
      :abbreviation => "MyString",
      :base_type => "MyString",
      :book_mainframe => "MyString",
      :periodicity => "MyString",
      :periodicity_details => "MyString",
      :data_retention_type => "MyString",
      :extractor_file_type => "MyString",
      :room_1_notes => "MyText",
      :mnemonic => "MyString",
      :cd5_portal_source_code => 1,
      :cd5_portal_source_name => "MyString",
      :cd5_portal_target_code => 1,
      :cd5_portal_target_name => "MyString",
      :hive_table_name => "MyString",
      :mainframe_storage_type => "MyString",
      :room_2_notes => "MyText"
    ))
  end

  it "renders the edit origin form" do
    render

    assert_select "form[action=?][method=?]", origin_path(@origin), "post" do

      assert_select "input#origin_file_name[name=?]", "origin[file_name]"

      assert_select "input#origin_file_description[name=?]", "origin[file_description]"

      assert_select "input#origin_created_in_sprint[name=?]", "origin[created_in_sprint]"

      assert_select "input#origin_updated_in_sprint[name=?]", "origin[updated_in_sprint]"

      assert_select "input#origin_abbreviation[name=?]", "origin[abbreviation]"

      assert_select "input#origin_base_type[name=?]", "origin[base_type]"

      assert_select "input#origin_book_mainframe[name=?]", "origin[book_mainframe]"

      assert_select "input#origin_periodicity[name=?]", "origin[periodicity]"

      assert_select "input#origin_periodicity_details[name=?]", "origin[periodicity_details]"

      assert_select "input#origin_data_retention_type[name=?]", "origin[data_retention_type]"

      assert_select "input#origin_extractor_file_type[name=?]", "origin[extractor_file_type]"

      assert_select "textarea#origin_room_1_notes[name=?]", "origin[room_1_notes]"

      assert_select "input#origin_mnemonic[name=?]", "origin[mnemonic]"

      assert_select "input#origin_cd5_portal_source_code[name=?]", "origin[cd5_portal_source_code]"

      assert_select "input#origin_cd5_portal_source_name[name=?]", "origin[cd5_portal_source_name]"

      assert_select "input#origin_cd5_portal_target_code[name=?]", "origin[cd5_portal_target_code]"

      assert_select "input#origin_cd5_portal_target_name[name=?]", "origin[cd5_portal_target_name]"

      assert_select "input#origin_hive_table_name[name=?]", "origin[hive_table_name]"

      assert_select "input#origin_mainframe_storage_type[name=?]", "origin[mainframe_storage_type]"

      assert_select "textarea#origin_room_2_notes[name=?]", "origin[room_2_notes]"
    end
  end
end
