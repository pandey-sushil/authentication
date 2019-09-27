# Helper service for session related functionality
#

module Authentication
  class SessionService

    # Initialized with parameters to identify session as well metainfo to log extra 
    # information to analyse a session later.
    #
    # Args params :: :account, :username, :meta_info, :auth_token, :ip
    # Author :: Sushil
    # Review :: Shivam
    def initialize(args)
      @account    = args['account']
      @username   = args['username']
      @meta_info  = args['meta_info']
      @auth_token = args['auth_token']
      @ip         = args['ip']
    end

    ## Create session with metainfo and update cache
    # Author :: Sushil
    # Review :: Shivam
    def create_session
      raw_token, enc_token = account.create_session(ip, meta_info)
      set_account_cache(account, raw_token)
      set_auth_token_cache(enc_token, raw_token)
      return raw_token
    end

    ## marks session inactive and deletes cache
    # Author :: Sushil
    # Review :: Shivam
    def destroy_session
      session = Authentication::Session.active_token_session(auth_token)
      session.logout unless session.nil?
      clear_cache(auth_token)
      return {'success' => true}
    end

    ## returns data to be cached
    # Author :: Sushil
    # Review :: Shivam
    def set_session_details
      session = Authentication::Session.active_token_session(auth_token)
      session && set_account_cache(session.account, auth_token)
    end

    private
    attr_reader :meta_info, :username, :auth_token, :ip

    ## caches the account data to the Redis
    # Author :: Sushil
    # Review :: Shivam
    def set_account_cache(account, raw_token)
      Authentication::RedisStore.instance.json_set(raw_token, data_to_cache(account))
      return {raw_token => data_to_cache(account)}
    end

    ## caches the auth_token with raw_token to Redis for deleting account_data later
    # Author :: Shashank
    # Review :: Shivam
    def set_auth_token_cache(auth_token, raw_token)
      Authentication::RedisStore.instance.set(auth_token, raw_token)
    end

    ## delete key from redis
    # Author :: Sushil
    # Review :: Shivam
    def clear_cache(auth_token)
      Authentication::RedisStore.instance.delete(auth_token)
    end

    ## Get data from redis cache
    # Author :: Sushil
    # Review :: Shivam
    def cached_session_data
      Authentication::RedisStore.instance.json_get(auth_token)
    end

    ## Get account object
    # Author :: Sushil
    # Review :: Shivam
    def account
      @account ||= Authentication::Account.find_by(email: username)
    end

    ## data to cached
    # Author :: Sushil
    # Review :: Shivam
    def data_to_cache(account)
      {
        'account_id' => account.id,
        'roles'      => account.roles
      }
    end
  end
end

