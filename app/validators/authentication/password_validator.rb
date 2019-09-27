# Validator for matching passwords for login functioanlity
#

module Authentication
  class PasswordValidator

    # Initialized with parameters to validate the password params 
    # provided by the user  
    #
    # Args params :: :account, :password, :password_confirmation, :reset_password_token
    # Author :: Sushil
    # Review :: Shivam
    def initialize(args)
      @username               = args['username']
      @password               = args['password']
      @password_confirmation  = args['password_confirmation']
      @reset_password_token   = args['reset_password_token']
    end

    ## Validate allowed to request reset password
    # Author :: Sushil
    # Review :: Shivam
    def validate_reset
      return return_hash(false, 'INVALID_USERNAME') if !valid_account?
      return return_hash(true)
    end

    ## validate if the reset password link is valid
    # Author :: Sushil
    # Review :: Shivam
    def validate_link
      return return_hash(false, 'INVALID_RESET_TOKEN') if !valid_token?
      return return_hash(false, 'PASSWORD_MISMATCH') if password_mismatch?
      return return_hash(false, 'INVALID_PASSWORD') unless valid_password?
      return return_hash(true)
    end

    private
    attr_reader :username, :password, :password_confirmation, :reset_password_token, :account

    # check if valid account
    #
    # Author :: Sushil
    # Review :: Shivam
    def valid_account?
      Authentication::Account.exists?(email: username)
    end

    # Check if valid link & link sent at is within given range
    # if reset_password_sent_at is blank link will remain till its been used.
    #
    # Author :: Sushil
    # Review :: Shivam
    def valid_token?
      return false unless reset_password_token.present?
      @account = Authentication::Account.reset_token_account(reset_password_token)
      @account.present? && @account.reset_password_expires_at && @account.reset_password_expires_at >= Time.now
    end

    # Check if password mismatched
    # Author :: Sushil
    # Review :: Shivam
    def password_mismatch?
      !(password.eql?password_confirmation)
    end

    # Return structure
    # Author :: Sushil
    # Review :: Shivam
    def return_hash(success, error_code='')
      {'success' => success, 'error_code' => error_code}
    end

    ## Validate
    # one Upper case
    # one special character
    # one number
    # length between 8 to 24
    #
    # Author :: Sushil
    # Review :: Shivam
    def valid_password?
      if @account.roles.include?('partner')
        password.present? &&  password.match(/^.*(?=.{6,}).*$/).present?
      else
        password.present? && password.match(/^.*(?=.{8,24})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).*$/).present?
      end
    end
  end
end
