# Validator for session creation
# This checks for valid account, password, max login attemtps, max sessions count
#

module Authentication
  class SessionValidator
    MAX_ACTIVE_SESSIONS = 30
    MAX_ACTIVE_PARTNER_SESSIONS = 300
    MAX_LOGIN_ATTEMPTS = 5

    attr_reader :login_attempt_exceeded

    # Initialized with parameters to validate the user session.
    #
    # Args params :: :account, :username, :password, :gitd, :auth_token
    # Author :: Sushil
    # Review :: Shivam
    def initialize(args)
      @account        = args['account']
      @username       = args['username']
      @password       = args['password']
      @gid            = args['gid']
      @auth_token     = args['auth_token']
    end

    ## Validations for login via password
    # Author :: Sushil
    # Review :: Shivam
    def validate_login
      return return_hash(false, 'INVALID_USERNAME_PASSWORD') unless valid_account?
      return return_hash(false, 'INVALID_USERNAME_PASSWORD') unless valid_password?
      return return_hash(false, 'SESSIONS_EXCEEDED') unless valid_partner_sessions?
      return return_hash(true)
    end

    ## Validations for login via google account
    # Author :: Sushil
    # Review :: Shivam
    def validate_google_login
      return return_hash(false, 'INVALID_USERNAME_PASSWORD') unless valid_account?
      return return_hash(false, 'INVALID_USERNAME_PASSWORD') unless valid_google_id?
      return return_hash(false, 'SESSIONS_EXCEEDED') unless valid_sessions?
      return return_hash(true)
    end

    def validate_superadmin_login
      return return_hash(false, 'INVALID_USERNAME_PASSWORD') unless valid_account?
      return return_hash(false, 'SESSIONS_EXCEEDED') unless valid_partner_sessions?
      return return_hash(true)
    end

    ## Check valid number of sessions
    # Author :: Sushil
    # Review :: Shivam
    def valid_sessions?
      Authentication::Session.active_sessions_count(account.id) <= MAX_ACTIVE_SESSIONS
    end

    ## Check valid number of sessions for partners
    def valid_partner_sessions?
      Authentication::Session.active_sessions_count(account.id) <= MAX_ACTIVE_PARTNER_SESSIONS
    end

    # Validate customer login
    #
    # Author :: Rachit
    # Date :: 18/04/2018
    # Review:: Shivam
    def validate_customer_login
      return return_hash(false, 'INVALID_USERNAME_PASSWORD') unless valid_account?
      return return_hash(false, 'INVALID_USERNAME_PASSWORD') unless valid_customer_password?
      return return_hash(true)
    end

    def login_attempt_exceeded
      @account.try(:login_attempts).to_i >= MAX_LOGIN_ATTEMPTS
    end

    private
    attr_reader :username, :password, :auth_token, :account, :gid

    ## Return structure of the service
    # Author :: Sushil
    # Review :: Shivam
    def return_hash(success, error_code=nil)
      { 'success' => success, 'error_code' => error_code }
    end

    ## Check if valid account with given username
    # Author :: Sushil
    # Review :: Shivam
    def valid_account?
      @account ||= username.present? && Authentication::Account.find_by(email: username)
      account.present? && @account.update_columns(login_attempts: @account.login_attempts + 1, updated_at: Time.current)
    end

    ## Check if given password matches account's password
    # Author :: Sushil
    # Review :: Shivam
    def valid_password?
      Authentication::Encryptor.compare(account.encrypted_password, password)
    end

    ## Check if google id matches account's gid
    # Author :: Sushil
    # Review :: Shivam
    def valid_google_id?
      Authentication::Comparator.secure_compare(account.gid, gid)
    end

    # Check if given password matches account's customer password
    #
    # Author :: Rachit
    # Date :: 18/04/2018
    # Review :: Shivam
    def valid_customer_password?
      Authentication::Encryptor.compare(account.customer_password, [password, ::GlobalConstant::CUSTOMER_PEPPER].join)
    end
  end
end
