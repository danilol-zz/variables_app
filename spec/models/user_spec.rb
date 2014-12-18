# encoding : utf-8
require 'rails_helper'

describe User do
  context "attributes validation" do
    context 'name' do
      it { should respond_to :name }
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
    end

    context 'profile' do
      it { should respond_to :profile }
      it { should validate_presence_of(:profile) }
      it { expect(User::PROFILES).to eq ["sala1", "sala2"] }
    end

    context 'password' do
      it { should respond_to :password }
      it { should respond_to :password_confirmation }
      it { should validate_presence_of(:password) }
      it { should ensure_length_of(:password).is_at_least(5) }
      it { should ensure_length_of(:password).is_at_most(40) }
    end

    context 'email' do
      it { should respond_to :email }
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email) }

      invalid_emails = ["b lah","bälah","b@lah","bülah","bßlah","b!lah","b%lah","b)lah"]
      invalid_emails.each do |s|
        it { should_not allow_value(s).for(:email) }
      end
    end

    context 'role' do
      it { should respond_to :role }
    end
  end

  context "#room1?" do
    context "valid room1?" do
      it "should check the status" do
        user = FactoryGirl.create(:user, profile: Constants::STATUS[:SALA1])
        expect(user.room1?).to be_truthy
      end
    end

    context "invalid room1?" do
      it "should check the status" do
        user = FactoryGirl.create(:user, profile: Constants::STATUS[:SALA2])
        expect(user.room1?).to be_falsy
      end
    end
  end

  context "#room2?" do
    context "valid room2?" do
      it "should check the status" do
        user = FactoryGirl.create(:user, profile: Constants::STATUS[:SALA2])
        expect(user.room2?).to be_truthy
      end
    end

    context "invalid room2?" do
      it "should check the status" do
        user = FactoryGirl.create(:user, profile: Constants::STATUS[:SALA1])
        expect(user.room2?).to be_falsy
      end
    end
  end

  describe ".authenticate" do
    let(:attrs) {
      {
        :email => "zekitow@gmail.com",
        :name => "José Ribeiro",
        :profile => "Sala 1",
        :password => "123456",
        :password_confirmation => "123456"
      }
    }

    before { User.new(attrs).save }
    after  { User.delete_all }

    context "when user and password is valid" do
      subject { User.authenticate('zekitow@gmail.com','123456') }
      it { should_not be_nil }

    end

    context "when user and password is invalid" do
      subject { User.authenticate('zekitow@gmail.com.br','xxxxx') }
      it { should be_nil }
    end
  end

  context ".can_save?" do
    context "room 1 is creating an origin" do
      before do
        @user = FactoryGirl.create(:user, profile: 'sala1' )
        @origin = FactoryGirl.build(:origin)
      end

      it "grants access to users" do
        expect(@user.can_access?(@origin)).to be_truthy
      end
    end

    context "room 1 is editing the origin" do
      before do
        @user = FactoryGirl.create(:user, profile: 'sala1' )
        @origin = FactoryGirl.create(:origin)
      end

      it "grants access to users" do
        expect(@user.can_access?(@origin)).to be_truthy
      end
    end

    context "room 1 is editing room2 origin" do
      before do
        @user = FactoryGirl.create(:user, profile: 'sala1' )
        @origin = FactoryGirl.create(:origin, status: 'sala2')
      end

      it "grants access to users" do
        expect(@user.can_access?(@origin)).to be_falsy
      end
    end

    context "room 2 is editing room2 origin" do
      before do
        @user = FactoryGirl.create(:user, profile: 'sala2' )
        @origin = FactoryGirl.create(:origin, status: 'sala2')
      end

      it "grants access to users" do
        expect(@user.can_access?(@origin)).to be_truthy
      end
    end

    context "room 2 is editing finished origin" do
      before do
        @user = FactoryGirl.create(:user, profile: 'sala2' )
        @origin = FactoryGirl.create(:origin, status: 'producao')
      end

      it "grants access to users" do
        expect(@user.can_access?(@origin)).to be_falsy
      end
    end
    context "room 1 is editing finished origin" do
      before do
        @user = FactoryGirl.create(:user, profile: 'sala1' )
        @origin = FactoryGirl.create(:origin, status: 'producao')
      end

      it "grants access to users" do
        expect(@user.can_access?(@origin)).to be_truthy
      end
    end
  end
end
