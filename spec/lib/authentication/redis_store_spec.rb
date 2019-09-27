require 'rails_helper'

RSpec.describe Authentication::RedisStore do


  describe ".json_set" do
    before(:each) {@redis_store = Authentication::RedisStore.instance}
    it "should not set redis key for string value" do
      key = Faker::Lorem.word
      value = Faker::Lorem.sentence
      expect(@redis_store.json_set(key, value)).to eql(false)
    end

    it "should set redis key for hash value" do
      key = Faker::Lorem.word
      value = { Faker::Lorem.word => Faker::Lorem.sentence }
      @redis_store.json_set(key, value)
      expect(@redis_store.json_get(key)).to eql(value)
    end
  end

  describe ".json_get" do
    before(:each) {
      @redis_store = Authentication::RedisStore.instance
      @key    = Faker::Lorem.word
      @value  = { Faker::Lorem.word => Faker::Lorem.sentence }
      @redis_store.json_set(@key, @value)
    }

    it "should get the key value" do
      expect(@redis_store.json_get(@key)).to eql(@value)
    end

    it "should return Hash" do
      expect(@redis_store.json_get(@key).is_a?Hash).to eql(true)
    end
  end

  describe ".delete" do
    before(:each) {
      @redis_store = Authentication::RedisStore.instance
      @key    = Faker::Lorem.word
      @value  = { Faker::Lorem.word => Faker::Lorem.sentence }
      @redis_store.json_set(@key, @value)
    }

    it "should delete key" do
      @redis_store.delete(@key)
      expect(@redis_store.json_get(@key)).to eql(nil)
    end
  end

  describe ".expire" do
    before(:each) {
      @redis_store = Authentication::RedisStore.instance
      @key    = Faker::Lorem.word
      @value  = { Faker::Lorem.word => Faker::Lorem.sentence }
      @redis_store.json_set(@key, @value)
    }

    it "should expire the key" do
      @redis_store.expire(@key, 0)
      expect(@redis_store.json_get(@key)).to eql(nil)
    end

    it "should expire the key in 10 minutes" do
      @redis_store.expire(@key, 10*60)
      expect(@redis_store.json_get(@key)).to eql(@value)
    end
  end
end
