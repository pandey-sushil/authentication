require 'rails_helper'

RSpec.describe Authentication::Encryptor do
  describe "#digest" do
    it "should return nil" do
      expect(Authentication::Encryptor.digest(nil)).to eql(nil)
    end

    it "should return not nil" do
      expect(Authentication::Encryptor.digest(Faker::Lorem.word)).not_to eql(nil)
    end
  end

  describe "#compare" do
    it "should compare password" do
      password = Faker::Lorem.word
      hash     = Authentication::Encryptor.digest(password)
      expect(Authentication::Encryptor.compare(hash, password)).to eql(true)
    end

    it "should return false" do
      password = Faker::Lorem.sentence
      hash     = Authentication::Encryptor.digest(Faker::Lorem.word)
      expect(Authentication::Encryptor.compare(hash, password)).to eql(false)
    end
  end
end
