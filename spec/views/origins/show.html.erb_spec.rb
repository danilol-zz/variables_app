require 'rails_helper'

RSpec.describe "origins/show", :type => :view do
  before(:each) do
    @origin = assign(:origin, Origin.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/File Name/)
    expect(rendered).to match(/File Description/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Abbreviation/)
    expect(rendered).to match(/Base Type/)
    expect(rendered).to match(/Book Mainframe/)
    expect(rendered).to match(/Periodicity/)
    expect(rendered).to match(/Periodicity Details/)
    expect(rendered).to match(/Data Retention Type/)
    expect(rendered).to match(/Extractor File Type/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Mnemonic/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Cd5 Portal Source Name/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Cd5 Portal Target Name/)
    expect(rendered).to match(/Hive Table Name/)
    expect(rendered).to match(/Mainframe Storage Type/)
    expect(rendered).to match(/MyText/)
  end
end
