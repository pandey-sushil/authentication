# This controller handles password setting/resetting functionality
#

module Authentication
  class PasswordsController < ApplicationController

    # POST /:entitiy/password
    # Generate reset password url
    #
    # Author :: Sushil
    # Review :: Shivam
    def create
      valid_hash = Authentication::PasswordValidator.new(
        'username' => password_params['email']).validate_reset
      render_bad_request(valid_hash) && return unless valid_hash['success']
    end

    # PUT /:entity/password
    # Update password
    #
    # Author :: Sushil
    # Review :: Shivam
    def update
      valid_hash = Authentication::PasswordValidator.new(
        'reset_password_token'  => reset_params['reset_password_token'],
        'password'              => reset_params['password'],
        'password_confirmation' => reset_params['password_confirmation']).validate_link
      render_bad_request(valid_hash) && return unless valid_hash['success']
    end

    private

    ## params for generating reset password link
    #
    # Author :: Sushil
    # Review :: Shivam
    def password_params
      params.permit(:email)
    end

    ## params to reset password
    #
    # Author :: Sushil
    # Review :: Shivam
    def reset_params
      params.permit(:reset_password_token, :password, :password_confirmation)
    end
  end
end
