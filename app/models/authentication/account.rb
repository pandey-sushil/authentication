# This is the base model to map user's account functionality.
# It contains :
# email, password related fields to maintain login functionality
# roles for access management
#

module Authentication
  class Account < Authentication::ApplicationRecord

    validates :email, presence: true
    validates :email, uniqueness: true
    has_many :sessions
    serialize :roles, Array

    scope :with_email_like, ->(query) {where("email like ? and roles like '%base_admin%'","%#{query}%")}
    scope :with_reset_password_token, ->(token) {where(reset_password_token: token)}
    scope :with_customer_token, -> (token) {where(customer_token: Authentication::TokenGenerator.digest('customer_token', token))}
    scope :with_customer_reset_password_token, -> (token) {where(customer_reset_password_token: Authentication::TokenGenerator.digest('customer_reset_password_token', token))}
    scope :with_customer_email_and_customer_token, ->(email, token) {where(email: email, customer_token: token)}
    scope :with_customer_email_and_customer_reset_password_token, ->(email, token) {where(email: email, customer_reset_password_token: token)}
    scope :is_customer_registered, ->(email) {where(email: email, customer_status: 1)}
    scope :non_customer, -> {where.not(gid: nil)}

    activity_logged with_triggers: true,
                    only: [:reset_password_token, :customer_password,
                           :customer_token, :customer_reset_password_token, :customer_status],
                    on: [:update]

    ## stores the hashed password from given string
    # Author :: Sushil
    # Review :: Shivam
    def password=(new_password)
      self.encrypted_password = password_digest(new_password)
    end

    ## compares db password with input password
    # Author :: Sushil
    # Review :: Shivam
    def valid_password?(password)
      Authentication::Encryptor.compare(self.encrypted_password, password)
    end

    ## create new account session.
    # Author :: Sushil
    # Review :: Shivam
    def create_session(ip, meta_info={})
      raw, enc = Authentication::TokenGenerator.generate(Authentication::Session, 'authentication_token')
      Authentication::Session.create({
        'authentication_token' => enc,
        'meta_info'            => meta_info,
        'ip'                   => ip,
        'account_id'           => self.id
      })
      return raw, enc
    end

    ## validates if the given token is valid
    #
    # Author :: Sushil
    # Review :: Shivam
    def self.reset_token_account(base64_token)
      hex_token = Authentication::TokenGenerator.digest('reset_password_token', base64_token)
      self.with_reset_password_token(hex_token).last
    end

    # Validates if the given customer email and token (auth/reset password) is valid
    #
    # Author :: Rachit
    # Review :: Shivam
    def self.customer_email_token_account(email, base64_token, token_type)
      hex_token = Authentication::TokenGenerator.digest(token_type, base64_token)
      self.send("with_customer_email_and_#{token_type}", email, hex_token).last
    end

    # Validates if the given customer is already registered
    #
    # Author :: Rachit
    # Review :: Shivam
    def self.customer_registered(email)
      self.is_customer_registered(email).first
    end

    ## update role existing account
    # Author :: Sushil
    # Review :: Shivam
    def update_roles(roles)
      self.roles |= roles
      self.save!
    end

    private

    ## Generates the hashed password
    # Author :: Sushil
    # Review :: Shivam
    def password_digest(password)
      Authentication::Encryptor.digest(password)
    end
  end
end
