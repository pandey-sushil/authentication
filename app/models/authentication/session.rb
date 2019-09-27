# This model is used to maintain sessions for accounts
# It contains :
# foreign key to account
# fields to maintain sessions i.e. token, status
# metadata fields like metainfo, ip
#
module Authentication
  class Session < Authentication::ApplicationRecord
    enum status: {inactive: 0, active: 1}
    serialize :meta_info, JSON
    belongs_to :account, class_name: 'Authentication::Account'

    # define custom callback for logout function to do 'after' operations
    define_model_callbacks :logout, only: :after

    scope :select_account, -> { select(:account_id) }
    scope :with_token, -> (token) {where(authentication_token: token)}

    after_logout :update_logout_details

    after_create :reset_login_attempt_counter

    # Get the count of active sessions
    # Author :: Sushil
    # Review :: Shivam
    def self.active_sessions_count(account_id)
      self.active.where(account_id: account_id).count
    end

    ## validates if the given token is valid
    # Author :: Sushil
    # Review :: Shivam
    def self.active_token_session(base64_token)
      hex_token = Authentication::TokenGenerator.digest('authentication_token', base64_token)
      self.active.with_token(hex_token).last
    end

    ## Mark session object as inactive
    # Author :: Sushil
    # Review :: Shivam
    def logout
      run_callbacks :logout do
        self.inactive!
      end
    end

    def update_logout_details
      self.update_attributes(inactive_at: Time.current, inactive_by: 'User')
    end

    def reset_login_attempt_counter
      self.account.update_attributes(login_attempts: 0)
    end
  end
end
