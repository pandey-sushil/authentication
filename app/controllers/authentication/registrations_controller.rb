# This controller handles account registration functionality
#

module Authentication
  class RegistrationsController < ApplicationController

    # when moved as different application can be used for registration via app
    # Validate and create Account
    #
    # Author :: Sushil
    # Review :: Shivam
    def create
      valid_hash = validate_registration
      render_bad_request(valid_hash) && return unless valid_hash['success']
      register
      respond_to_registration
    end

    private

    # Author :: Sushil
    # Review :: Shivam
    def registration_params
      params.permit(:username, :password, :entity, :roles)
    end

    # Author :: Sushil
    # Review :: Shivam
    def entity
      registration_params[:entity]
    end

    # Author :: Sushil
    # Review :: Shivam
    def validate_registration
      Authentication::RegistrationValidator.new({
        'username' => registration_params['username'],
        'password' => registration_params['password'],
      }).validate
    end

    # Author :: Sushil
    # Review :: Shivam
    def register
      Authentication::RegistrationService.new({
        'username' => registration_params['username'],
        'password' => registration_params['password'],
        'role'     => registration_params['roles']
      }).register
    end

    # Author :: Sushil
    # Review :: Shivam
    def respond_to_registration
      respond_to do |format|
        format.all { render json: {success: true}} #render from serializer
      end
    end
  end
end
