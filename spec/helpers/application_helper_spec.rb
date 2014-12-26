require 'rails_helper'

describe 'ApplicationHelper' do

  describe '#boolean_to_sim_nao' do
    context 'boolean value is true' do
      it "returns 'Sim'" do
        expect(boolean_to_sim_nao(true)).to eq "Sim"
      end
    end
    context 'boolean value is false' do
      it "returns 'Não'" do
        expect(boolean_to_sim_nao(false)).to eq "Não"
      end
    end
  end

  describe '#this_mode_name' do
    context 'when model name is Origin' do
      it "returns Origem" do
        expect(this_model_name(Origin)).to eq "Origem"
      end
    end
    context 'when model name is OriginField' do
      it "returns Campos de origem" do
        expect(this_model_name(OriginField)).to eq "Campos de origem"
      end
    end
   end

end

