# Validator for matching passwords & pre registration check
#

module Authentication
  class RegistrationValidator

    # Initialized with parameters needed to validate the params
    # sent for user registration
    #
    # Args params :: :username, :password
    # Author :: Sushil
    # Review :: Shivam
    def initialize(args)
      @username = args['username']
      @password = args['password']
    end

    ## validate registration
    # Author :: Sushil
    # Review :: Shivam
    def validate
      # return return_hash(false, 'ALREADY_REGISTERED') if (already_registered?)
      return return_hash(false, 'INVALID_PASSWORD') unless valid_password?
      return return_hash(true)
    end

    ## Check if user is already registered with email
    # Author :: Sushil
    # Review :: Shivam
    def already_registered?
      email = username.gsub(/\+.*@/, '@')
      (Authentication::Account.exists?(email: email))
    end

    private

    attr_reader :username, :password

    ## Return structure of the service
    # Author :: Sushil
    # Review :: Shivam
    def return_hash(success, error_code=nil)
      {
        'success'     => success,
        'error_code'  => error_code
      }
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
      password.present? && password.match(/^(?=.*[A-Z])(?=.*[\!\@\#\$\&\*])(?=.*[0-9]).{8,24}$/).present?
    end
  end
end
