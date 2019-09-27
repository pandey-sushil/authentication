require 'rails_helper'

RSpec.describe Authentication::TokenGenerator do
  describe "#friendly_token" do
    it "should return string of length 20" do
      expect((Authentication::TokenGenerator.friendly_token).length).to eql(20)
    end

    it "should return string of length 40" do
      expect((Authentication::TokenGenerator.friendly_token(40)).length).to eql(40)
    end
  end

  describe "#digest" do
    before(:each) {@raw_token = Authentication::TokenGenerator.friendly_token}
    it "should return false if nil raw token" do
      expect(Authentication::TokenGenerator.digest('reset_password_token', nil)).to eql(false)
    end

    it "should return digest" do
      expect(Authentication::TokenGenerator.digest('reset_password_token', @raw_token)).not_to eql(nil)
    end
  end

  describe "#generate" do
    before(:each) {@tokens = Authentication::TokenGenerator.generate(Authentication::Account, 'reset_password_token')}
    it "should return array" do
      expect(@tokens.is_a?Array).to eql(true)
    end

    it "should return raw and encrypted keys" do
      raw, enc = @tokens
      expect(Authentication::TokenGenerator.digest('reset_password_token', raw)).to eql(enc)
    end
  end
end
