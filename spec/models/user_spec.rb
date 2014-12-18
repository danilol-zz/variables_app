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

    context "valid room1?" do
      before do
        @user = FactoryGirl.create(:user, profile: Constants::STATUS[:SALA1])
      end

      it "should check the room" do
        expect(@user.room1?).to eq true
      end
    end

    context "invalid room1?" do
      before do
        @user = FactoryGirl.create(:user, profile: Constants::STATUS[:SALA2])
      end

      it "should check the room" do
        expect(@user.room1?).to eq false
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
end
