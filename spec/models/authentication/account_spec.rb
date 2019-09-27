require 'rails_helper'

RSpec.describe Authentication::Account, type: :model do
  describe "Validations" do
    it {should validate_presence_of(:email)}
    it {should validate_uniqueness_of(:email)}
  end

  describe "Associations" do
    it { should have_many(:sessions) }
  end

  describe "Scopes" do
    describe "#with_email_like" do
      let!(:account) {FactoryBot.create(:authentication_account, roles: ['base_admin'])}
      before(:each) { account }

      it "should return account" do
        expect(Authentication::Account.with_email_like('@').last).to eql([account])
      end
    end

    describe "#with_reset_password_token" do
      let!(:account) {FactoryBot.create(:authentication_account, reset_password_token: Faker)}
      before(:each) { account }

      it "" do
        { expect(Authentication::Account.with_email_like('@').last).to eql(account) }
      end
    end
  end
end
