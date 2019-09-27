# Helper service for registartion related logic
#

module Authentication
  class RegistrationService

    # Initialized with user credentials needed at the time of registering a user 
    #
    # Args params :: :username, :password, :role, :gid
    # Author :: Sushil
    # Review :: Shivam
    def initialize(args)
      @username = args['username']
      @password = args['password']
      @role     = args['role']
      @gid      = args['gid']
    end


    ##encrypts password and creates account
    # Author :: Sushil
    # Review :: Shivam
    def register
      enc_password = Authentication::Encryptor.digest(password)
      account = Authentication::Account.find_or_initialize_by({email: username})
      account.assign_attributes({'encrypted_password' => enc_password, 'gid' => gid})
      account.roles.concat(role.to_a).uniq!
      account.save!
      {'account_id' => account.id}
    end

    private
    attr_reader :username, :password, :role, :gid

  end
end
