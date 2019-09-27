# Interface for using redis as data store
#

require 'singleton'
module Authentication
  class RedisStore
    include Singleton

    def initialize
      uri    = URI.parse(Authentication::GlobalConstant::REDIS_URL)
      @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true, :namespace => "test:#{Rails.env}Cache")
    end

    ## Get the json structure of the key
    def json_get(key)
      value = redis.get(key)
      value && JSON.parse(value)
    end

    ## Set the value in json structure
    def json_set(key, value)
      return false unless value.is_a?Hash
      redis.set(key, value.to_json)
    end

    def get(key)
      redis.get(key)
    end

    def set(key, value)
      redis.set(key, value)
    end

    # Expire an item
    def expire(key, time)
      redis.expire(key, time)
    end

    ## delete key from redis
    def delete(key)
      redis.del(key)
    end

    private
    attr_reader :redis

  end
end
