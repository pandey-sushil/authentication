module Authentication
  module GlobalConstant
    env_constants = YAML.load_file(Rails.root.to_s + '/config/constants.yml')['constants']
    REDIS_URL     = env_constants['redis']['url']
    test_DEVS = %w(tech@test.com)
  end
end
