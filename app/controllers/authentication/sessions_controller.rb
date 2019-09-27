# This controller handles session CRUD functionality
#

module Authentication
  class SessionsController < ApplicationController

    before_action :authenticate_account, only: [:destroy]

    ## Validate & login user
    # Author :: Sushil
    # Review :: Shivam
    def create
      hash = validate_login
      render_unauthenticated(hash) && return unless hash['success']
      auth_token = create_session
      respond_session_create(auth_token)
    end

    ## Logout user
    # Author :: Sushil
    # Review :: Shivam
    def destroy
      destroy_response = Authentication::SessionService.new('auth_token' => @token).destroy_session
      respond_logout
    end

    private

    # set account
    # Author :: Sushil
    # Review :: Shivam
    def account
      @account ||= (auth_params[:username].present?) && Authentication::Account.find_by(email: auth_params[:username])
    end

    # authentication params
    # Author :: Sushil
    # Review :: Shivam
    def auth_params
      params.permit(:username, :password, :continue)
    end

    ## /:entity/login from url
    #
    # Author :: Sushil
    # Review :: Shivam
    def entity_param
      params.permit(:entity)
    end

    ## add info that need to be stored in sessions table
    # Author :: Sushil
    # Review :: Shivam
    def session_params
      {'user_agent' => request.env['HTTP_USER_AGENT'], 'entity' => entity_param['entity']}
    end

    # Call validator to validate login
    # Author :: Sushil
    # Review :: Shivam
    def validate_login
      Authentication::SessionValidator.new({'account' => account}.merge(auth_params)).validate_login
    end

    # Call service to create session
    # Author :: Sushil
    # Review :: Shivam
    def create_session
      Authentication::SessionService.new({
        'username' => auth_params['username'], 'meta_info' => session_params}
      ).create_session
    end

    # Response to session creation
    # Author :: Sushil
    # Review :: Shivam
    def respond_session_create(auth_token)
      respond_to do |format|
        format.all { render json: {success: true, auth_token: auth_token}} #render from serializer
      end
    end

    # Response to logout session
    # Author :: Sushil
    # Review :: Shivam
    def respond_logout
      respond_to do |format|
        format.all { render json: {success: true}} #render from serializer
      end
    end

    # Render unauthroized if session not present
    # Author :: Sushil
    # Review :: Shivam
    def authenticate_account
      auth_with_token
      render_unauthenticated({success: false}) unless @session.present?
    end

    # Check and set session from token
    # Author :: Sushil
    # Review :: Shivam
    def auth_with_token
      authenticate_with_http_token do |token, options|
        @session = Authentication::Session.active_token_session(token)
        @token = token
      end
    end
  end
end
