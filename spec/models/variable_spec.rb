require 'rails_helper'

describe Variable do

  it { should respond_to :name }
  it { should respond_to :sas_variable_def }
  it { should respond_to :sas_variable_domain }
  it { should respond_to :created_in_sprint }
  it { should respond_to :updated_in_sprint }
  it { should respond_to :sas_data_model_status }
  it { should respond_to :drs_bi_diagram_name }
  it { should respond_to :drs_variable_status }
  it { should respond_to :room_1_notes }
  it { should respond_to :physical_model_name_field }
  it { should respond_to :width_variable }
  it { should respond_to :decimal_variable }
  it { should respond_to :default_value }
  it { should respond_to :room_2_notes }

  context "statuses" do
    before do
      FactoryGirl.create(:variable, status: "Rascunho")
      FactoryGirl.create(:variable, status: "Rascunho")
      FactoryGirl.create(:variable, status: "Finalizado")
      FactoryGirl.create(:variable, status: "Finalizado")
      FactoryGirl.create(:variable, status: "Desenvolvimento")
      FactoryGirl.create(:variable, status: "Desenvolvimento")
      FactoryGirl.create(:variable, status: "Desenvolvimento")
      FactoryGirl.create(:variable, status: "Desenvolvimento")
      FactoryGirl.create(:variable, status: "Rascunho")
    end

    it "check the scopes" do
      expect(Variable.draft.count).to eq 3
      expect(Variable.development.count).to eq 4
      expect(Variable.done.count).to eq 2
    end
  end
end
