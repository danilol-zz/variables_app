require 'rails_helper'

RSpec.describe "origins/index", :type => :view do
  before(:each) do
    assign(:origins, [
      Origin.create!(
        :file_name => "File Name",
        :file_description => "File Description",
        :created_in_sprint => 1,
        :updated_in_sprint => 2,
        :abbreviation => "Abbreviation",
        :base_type => "Base Type",
        :book_mainframe => "Book Mainframe",
        :periodicity => "Periodicity",
        :periodicity_details => "Periodicity Details",
        :data_retention_type => "Data Retention Type",
        :extractor_file_type => "Extractor File Type",
        :room_1_notes => "MyText",
        :mnemonic => "Mnemonic",
        :cd5_portal_source_code => 3,
        :cd5_portal_source_name => "Cd5 Portal Source Name",
        :cd5_portal_target_code => 4,
        :cd5_portal_target_name => "Cd5 Portal Target Name",
        :hive_table_name => "Hive Table Name",
        :mainframe_storage_type => "Mainframe Storage Type",
        :room_2_notes => "MyText"
      ),
      Origin.create!(
        :file_name => "File Name",
        :file_description => "File Description",
        :created_in_sprint => 1,
        :updated_in_sprint => 2,
        :abbreviation => "Abbreviation",
        :base_type => "Base Type",
        :book_mainframe => "Book Mainframe",
        :periodicity => "Periodicity",
        :periodicity_details => "Periodicity Details",
        :data_retention_type => "Data Retention Type",
        :extractor_file_type => "Extractor File Type",
        :room_1_notes => "MyText",
        :mnemonic => "Mnemonic",
        :cd5_portal_source_code => 3,
        :cd5_portal_source_name => "Cd5 Portal Source Name",
        :cd5_portal_target_code => 4,
        :cd5_portal_target_name => "Cd5 Portal Target Name",
        :hive_table_name => "Hive Table Name",
        :mainframe_storage_type => "Mainframe Storage Type",
        :room_2_notes => "MyText"
      )
    ])
  end

  it "renders a list of origins" do
    render
    assert_select "tr>td", :text => "File Name".to_s, :count => 2
    assert_select "tr>td", :text => "File Description".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Abbreviation".to_s, :count => 2
    assert_select "tr>td", :text => "Base Type".to_s, :count => 2
    assert_select "tr>td", :text => "Book Mainframe".to_s, :count => 2
    assert_select "tr>td", :text => "Periodicity".to_s, :count => 2
    assert_select "tr>td", :text => "Periodicity Details".to_s, :count => 2
    assert_select "tr>td", :text => "Data Retention Type".to_s, :count => 2
    assert_select "tr>td", :text => "Extractor File Type".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Mnemonic".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Cd5 Portal Source Name".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Cd5 Portal Target Name".to_s, :count => 2
    assert_select "tr>td", :text => "Hive Table Name".to_s, :count => 2
    assert_select "tr>td", :text => "Mainframe Storage Type".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
