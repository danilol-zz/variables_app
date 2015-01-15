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

  describe '#this_model_name' do
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

  describe "#entity_path" do
    before { assign(:filter, entity) }

    subject { helper.entity_path }

    context "with invalid entity name" do
      context "when no entity name is passed" do
        let(:entity) { nil }

        it "returns an empty string" do
          expect(subject).to eq ""
        end
      end

      context "when invalid entity name is passed" do
        let(:entity) { "Invalid" }

        it "returns an empty string" do
          expect(subject).to eq "invalids"
        end
      end
    end

    context "with valid entity name" do
      context "when entity name is Origin" do
        let(:entity) { "Origin" }

        it "returns a valid string route" do
          expect(subject).to eq "origins"
        end
      end

      context "when entity name is Campaign" do
        let(:entity) { "Campaign" }

        it "returns a valid string route" do
          expect(subject).to eq "campaigns"
        end
      end

      context "when entity name is Variable" do
        let(:entity) { "Variable" }

        it "returns a valid string route" do
          expect(subject).to eq "variables"
        end
      end

      context "when entity name is Processid" do
        let(:entity) { "Processid" }

        it "returns a valid string route" do
          expect(subject).to eq "processids"
        end
      end

      context "when entity name is Table" do
        let(:entity) { "Table" }

        it "returns a valid string route" do
          expect(subject).to eq "tables"
        end
      end
    end
  end

  describe "#capitalized_name" do
    subject { capitalized_name(entity) }

    context "with invalid entity name" do
      context "when no entity name is passed" do
        let(:entity) { nil }

        it "returns an empty string" do
          expect(subject).to eq "<span class=\"translation_missing\" title=\"translation missing: pt.activerecord.models.one\">One</span>"
        end
      end

      context "when invalid entity name is passed" do
        let(:entity) { "Invalid" }

        it "returns an empty string" do
          expect(subject).to eq "<span class=\"translation_missing\" title=\"translation missing: pt.activerecord.models.invalid.one\">One</span>"
        end
      end
    end

    context "with valid entity name" do
      context "when entity name is Origin" do
        let(:entity) { "Origin" }

        it "returns a valid string route" do
          expect(subject).to eq "Origem"
        end
      end

      context "when entity name is Campaign" do
        let(:entity) { "Campaign" }

        it "returns a valid string route" do
          expect(subject).to eq "Campanha"
        end
      end

      context "when entity name is Variable" do
        let(:entity) { "Variable" }

        it "returns a valid string route" do
          expect(subject).to eq "Variável"
        end
      end

      context "when entity name is Processid" do
        let(:entity) { "Processid" }

        it "returns a valid string route" do
          expect(subject).to eq "Processo"
        end
      end

      context "when entity name is Table" do
        let(:entity) { "Table" }

        it "returns a valid string route" do
          expect(subject).to eq "Tabela"
        end
      end
    end
  end

  context ".status_screen_name" do
    subject { status_screen_name(name) }

    context "when name is blank"  do
      let(:name) { nil }

      it "returns an empty string" do
        expect(subject).to be_blank
      end
    end

    context "when name has value" do
      context "when name has less than 20 characters" do
        let(:name) { "testnamestring" }

        it "returns the same string" do
          expect(subject).to eq "testnamestring"
        end
      end

      context "when name has more than 20 characters" do
        let(:name) { "testnamestringbiggertha20characters" }

        it "returns the same string" do
          expect(subject).to eq "testnamestringbigger"
        end
      end
    end
  end
end
