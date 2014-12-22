require 'rails_helper'

RSpec.describe VariablesHelper, :type => :helper do
  describe VariablesHelper do
    after do
      User.destroy_all
      Variable.destroy_all
    end

    describe "reopen permission" do
      before { @current_user = user }

      context "when user is room1 profile" do
        context "when variable status is not production" do

          let(:user)     { FactoryGirl.create(:user, name: 'testhelper', email: 'teste@teste.com',  profile: 'sala1') }
          let(:variable) { FactoryGirl.create(:variable, status:  'sala1') }

          it "revokes access to button" do
            expect(helper.can_reopen?(variable)).to be_falsy
          end
        end

        context "when variable status is production" do
          let(:user)     { FactoryGirl.create(:user, name: 'testhelper', email: 'teste@teste.com',  profile: 'sala1') }
          let(:variable) { FactoryGirl.create(:variable, status:  'produção') }

          it "grants access to button" do
            expect(helper.can_reopen?(variable)).to be_truthy
          end
        end
      end

      context "when user is room2 profile" do
        context "when variable status is not production" do
          let(:user)     { FactoryGirl.create(:user, name: 'testhelper', email: 'teste@teste.com',  profile: 'sala2') }
          let(:variable) { FactoryGirl.create(:variable, status:  'sala2') }

          it "revokes access to button" do
            expect(helper.can_reopen?(variable)).to be_falsy
          end
        end

        context "when variable status is production" do
          let(:user)     { FactoryGirl.create(:user, name: 'testhelper', email: 'teste@teste.com',  profile: 'sala2') }
          let(:variable) { FactoryGirl.create(:variable, status:  'produção') }

          it "revokes access to button" do
            expect(helper.can_reopen?(variable)).to be_falsy
          end
        end
      end
    end

    describe "can_finish_room1?" do
      before { @current_user = user }

      context 'when user is room1 profile' do
        let(:user) { FactoryGirl.create(:user, name: 'testhelper', email: 'teste@teste.com',  profile: 'sala1') }

        context "when variable status is room2" do
          let(:variable) { FactoryGirl.create(:variable, status:  'sala2') }

          it "revokes access to button" do
            expect(helper.can_finish_room1?(variable)).to be_falsy
          end
        end

        context "when variable status is production" do
          let(:variable) { FactoryGirl.create(:variable, status:  'produção') }

          it "revokes access to button" do
            expect(helper.can_finish_room1?(variable)).to be_falsy
          end
        end

        context "when variable status is room1" do
          let(:variable) { FactoryGirl.create(:variable, status:  'sala1') }

          it "grants access to button" do
            expect(helper.can_finish_room1?(variable)).to be_truthy
          end
        end
      end
    end

    describe "can_finish_room2?" do
      before { @current_user = user }
      context 'when user is room2 profile' do
        let(:user) { FactoryGirl.create(:user, name: 'testhelper', email: 'teste@teste.com',  profile: 'sala2') }

        context "when variable status is room2" do
          let(:variable) { FactoryGirl.create(:variable, status:  'sala2') }

          it "revokes access to button" do
            expect(helper.can_finish_room2?(variable)).to be_truthy
          end
        end

        context "when variable status is production" do
          let(:variable) { FactoryGirl.create(:variable, status:  'produção') }

          it "revokes access to button" do
            expect(helper.can_finish_room2?(variable)).to be_falsy
          end
        end

        context "when variable status is room1" do
          let(:variable) { FactoryGirl.create(:variable, status:  'sala1') }

          it "grants access to button" do
            expect(helper.can_finish_room2?(variable)).to be_falsy
          end
        end
      end
    end
  end
end
