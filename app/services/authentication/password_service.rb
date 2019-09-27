# Helper service for password related functionality
#

module Authentication
  class PasswordService

    # Initialized with user credentials & varibales to support the lifecycle of password
    # i.e. setting, resetting
    #
    # Args params :: :roles_map, :expires_at, :reset_password_token, :password, :auth_token
    # Author :: Sushil
    # Review :: Shivam
    def initialize(args)
      @username             = args['username']
      @expires_at           = args['expires_at']
      @reset_password_token = args['reset_password_token']
      @password             = args['password']
      @auth_token           = args['auth_token']
    end

    # Generate reset password token
    #
    # Author :: Sushil
    # Review ::
    def generate_token
      account = Authentication::Account.find_by(email: username)
      reset_hash = reset_password(account, expires_at || Time.now + 24.hours)
      {'success' => true, 'reset_password_token' => reset_hash['raw_token'], 'expires_at' => reset_hash['expires_at']}
    end

    # Update password from reset password token
    #
    # Author :: Sushil
    # Review ::
    def update_password
      enc_password = Authentication::Encryptor.digest(password)
      account      = Authentication::Account.reset_token_account(reset_password_token)
      account.encrypted_password = enc_password
      account.reset_password_token, account.reset_password_expires_at = nil, nil
      account.save!
      {'success' => true}
    end

    # Create new password for the customer
    #
    # Author :: Sushil
    # Date :: 19/04/2018
    # Review ::
    def create_customer_password(token_type)
      enc_password = Authentication::Encryptor.digest([password, ::GlobalConstant::CUSTOMER_PEPPER].join)
      account = Authentication::Account.customer_email_token_account(username, auth_token, token_type)
      account.customer_password = enc_password
      account.customer_status = 1
      account.customer_reset_password_token = nil if token_type == 'customer_reset_password_token'
      account.save!
      {'success' => true}
    end

    # Change the customer password
    #
    # Author :: Sushil
    # Date :: 24/04/2018
    # Review ::
    def change_customer_password
      enc_password = Authentication::Encryptor.digest([password, ::GlobalConstant::CUSTOMER_PEPPER].join)
      account = Authentication::Account.find_by(email: username)
      account.customer_password = enc_password
      account.save!
      {'success' => true}
    end

    private
    attr_reader :username, :expires_at, :password, :reset_password_token, :auth_token

    ## Set reset password token and sent at time
    # Author :: Sushil
    # Review ::
    def reset_password(account, reset_expires_at)
      raw, enc = Authentication::TokenGenerator.generate(Authentication::Account, 'reset_password_token')
      account.reset_password_token        = enc
      account.reset_password_expires_at   = reset_expires_at
      # account.login_attempts = 0
      account.save
      return {'raw_token' => raw, 'expires_at' => reset_expires_at}
    end

  end
end
