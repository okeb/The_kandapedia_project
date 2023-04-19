class RodauthApp < Rodauth::Rails::App
  # primary configuration
  configure RodauthMain
  configure RodauthAdmin, :admin

  # secondary configuration
  # configure RodauthAdmin, :admin
  # account_lockouts' doesn't exist
  route do |r|
    rodauth.load_memory # autologin remembered users

    r.rodauth # route rodauth requests
    r.rodauth(:admin) # route admin rodauth requests

    # ==> Authenticating requests
    # Call `rodauth.require_account` for requests that you want to
    # require authentication for. For example:
    #
    # # authenticate /dashboard/* and /account/* requests
    # if r.path.start_with?("/user/logout") || r.path.start_with?("/account")
    if r.path.start_with?("logout")
      rodauth.require_account
    end

    rodauth.require_two_factor_authenticated if rodauth.uses_two_factor_authentication?

    # ==> Secondary configurations
    # r.rodauth(:admin) # route admin rodauth requests
  end
end
