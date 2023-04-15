class RodauthApp < Rodauth::Rails::App
  # primary configuration
  configure RodauthMain
  configure RodauthAdmin, :admin

  # secondary configuration
  # configure RodauthAdmin, :admin

  route do |r|
    rodauth.load_memory # autologin remembered users

    r.rodauth # route rodauth requests
    r.rodauth(:admin) # route admin rodauth requests

    # ==> Authenticating requests
    # Call `rodauth.require_account` for requests that you want to
    # require authentication for. For example:
    #
    # # authenticate /dashboard/* and /account/* requests
    # if r.path.start_with?("/dashboard") || r.path.start_with?("/account")
    #   rodauth.require_account
    # end

    if rodauth.uses_two_factor_authentication?
      rodauth.require_two_factor_authenticated
    end
    # ==> Secondary configurations
    # r.rodauth(:admin) # route admin rodauth requests
  end
end
