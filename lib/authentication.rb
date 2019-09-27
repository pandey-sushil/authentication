require "authentication/engine"
require 'yaml'

module Authentication
  # autoload :Encryptor, 'authentication/encryptor'
  # autoload :Comparator, 'authentication/comparator'
  # autoload :TokenGenerator, 'authentication/token_generator'
  # autoload :RedisStore, 'authentication/redis_store'

  # Mark these directories for auto load
  # Author :: Sushil
  # Review :: Sushil
  def self.load_dir
    [
      '/lib/authentication',
      '/app/validators/authentication',
      '/app/services/authentication'   ]
  end
end
