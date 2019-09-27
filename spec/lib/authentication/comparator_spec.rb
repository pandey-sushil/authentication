require 'rails_helper'

RSpec.describe Authentication::Comparator do
  describe "#secure_compare" do
    it "should return true" do
      fake_string = Faker::Lorem.word
      expect(Authentication::Comparator.secure_compare(fake_string, fake_string)).to eq(true)
    end

    it "should return false" do
      expect(Authentication::Comparator.secure_compare(Faker::Lorem.word, Faker::Lorem.sentence)).to eq(false)
    end
  end
end
