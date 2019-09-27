# Helper service for account related functionality
#

module Authentication
  class AccountService

    # Initialized with mapping of email id to roles used to update roles column in Account model
    # Params :: :roles_map
    # Author :: Sushil
    # Review :: Shivam
    def initialize(args)
      @roles_map    = args['roles_map']
    end

    # Admin Assign roles from dashboard
    # Author :: Sushil
    # Review :: Shivam
    def assign_roles
      roles_map.each do |role_obj|
        Authentication::Account.find_by_email(role_obj['email']).update_attributes(roles: role_obj['roles'])
      end
    end

    private

    attr_reader :roles_map

  end
end

