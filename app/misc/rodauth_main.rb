class RodauthMain < RodauthBase
  configure do
    # List of authentication features that are loaded.
    enable :create_account, :verify_account, :verify_account_grace_period,
           # :jwt,
           :remember, :confirm_password

    # See the Rodauth documentation for the list of available config options:
    # http://rodauth.jeremyevans.net/documentation.html

    # ==> General
    # The secret key used for hashing public-facing tokens for various features.
    # Defaults to Rails `secret_key_base`, but you can use your own secret key.
    # hmac_secret "d81de22f9bb96e7cc3fa27db371484df479dd98b32bb1e43d9408ae842b3f758ae8bae4a633af3dbc8b949d4e61664642236be68fcaf6da519ab3e49ee5e0810"

    # Specify the controller used for view rendering and CSRF verification.
    rails_controller { RodauthController }


    # Store account status in an integer column without foreign key constraint.
    account_status_column :status

    # Store password hash in a column instead of a separate table.
    account_password_hash_column :password_hash

    # Set password when creating account instead of when verifying.
    verify_account_set_password? false

    # Delete the account record when the user has closed their account.
    delete_account_on_close? true

    # Redirect to the app from login and registration pages if already logged in.
    already_logged_in { redirect login_redirect }

    # ==> Emails
    # verify account
    create_verify_account_email do
      RodauthMailer.verify_account(self.class.configuration_name, account_id, verify_account_key_value)
    end

    # ==> Flash
    # Match flash keys with ones already used in the Rails app.
    # flash_notice_key :success # default is :notice
    # flash_error_key :error # default is :alert

    # Override default flash messages.
    create_account_notice_flash 'Your account has been created. Please verify your account by visiting the confirmation link sent to your email address.'
    require_login_error_flash 'Login is required for accessing this page'
    # login_notice_flash nil

    # ==> Validation
    # Override default validation error messages.
    # no_matching_login_message "user with this email address doesn't exist"
    # already_an_account_with_this_login_message "user with this email address already exists"
    # password_too_short_message { "needs to have at least #{password_minimum_length} characters" }
    # login_does_not_meet_requirements_message { "invalid email#{", #{login_requirement_message}" if login_requirement_message}" }

    # Change minimum number of password characters required when creating an account.
    # password_minimum_length 8

    # ==> Remember Feature
    # Remember all logged in users.
    after_login { remember_login }
    after_two_factor_authentication { remember_login}

    # Or only remember users that have ticked a "Remember Me" checkbox on login.
    # after_login { remember_login if param_or_nil("remember") }

    # Extend user's remember period when remembered via a cookie
    # extend_remember_deadline? true

    # ==> Hooks
    # Validate custom fields in the create account form.
    # before_create_account do
    #   throw_error_status(422, 'email', 'must be present') if param('login').empty?
    # end

    # Perform additional actions after the account is created.
    # after_create_account do
    #   if param('terms_of_service').to_i != 0
    #     Profile.create!(account_id: account_id, username: param('username'), terms_of_service: param('terms_of_service'))
    #   else
    #     Profile.find_by!(account_id: account_id).destroy
    #     throw_error_status(422, 'terms_of_service', "can't be nil")
    #   end
    # end

    # Do additional cleanup after the account is closed.
    # after_close_account do
    #   Profile.find_by!(account_id: account_id).destroy
    # end

    # ==> Redirects

    # Redirect to wherever login redirects to after account verification.
    verify_account_redirect { login_redirect }

    # Redirect to login page after password reset.
    reset_password_redirect { login_path }

    # Ensure requiring login follows login route changes.
    require_login_redirect { login_path }

    # ==> Deadlines
    # Change default deadlines for some actions.
    # verify_account_grace_period 3.days
    # reset_password_deadline_interval Hash[hours: 6]
    # verify_login_change_deadline_interval Hash[days: 2]
    # remember_deadline_interval Hash[days: 30]

    # before_otp_auth_route do
    #   if recovery_code_match?(param(otp_auth_param))
    #     two_factor_authenticate("recovery_code")
    #   end
    # end

    prefix '/user'
  end
end
