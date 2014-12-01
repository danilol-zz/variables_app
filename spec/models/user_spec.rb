# encoding : utf-8
require 'rails_helper'

describe User do
  it { should respond_to :email }
  it { should respond_to :name }
  it { should respond_to :profile }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :role }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:profile) }
  it { should validate_presence_of(:password) }

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
