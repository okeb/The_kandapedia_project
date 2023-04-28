class RodauthAdmin < RodauthBase
  configure do
    # List of authentication features that are loaded.
    enable :password_complexity

    accounts_table :admin_accounts
    # password_hash_table :admin_password_hashes # if using database authentication functions
    # verify_account_table :admin_verification_keys
    # verify_login_change_table :admin_login_change_keys
    # reset_password_table :admin_password_reset_keys
    # remember_table :admin_remember_keys

    rails_controller { Admin::RodauthController }

    prefix '/admin'

    session_key_prefix 'admin_'

    remember_cookie_key "_admin_remember"

    # Amount invalid logins allowed before your account is locked
    max_invalid_logins 3

    flash_error_key :alert
    flash_notice_key :notice

    after_create_account do
      @username = if !param('username').nil? && !param('username').empty?
                    param('username')
                  else
                    "Nouvel #{account_type} #{account_id}"
                  end
      @account = AdminAccount.find_by(id: account_id)
      @terms = 1

      @profile = @account.create_profile(username: @username, terms_of_service: @terms)
      @profile.save!
    end

    # Delete the account record when the user has closed their account.
    delete_account_on_close? false

    # already_an_account_with_this_login_message "user with this email address already exists"
    password_too_short_message { "needs to have at least #{password_minimum_length} characters" }

    # Change minimum number of password characters required when creating an account.
    password_minimum_length 8

    default_redirect '/admin'

    new_recovery_code { SecureRandom.uuid }

  end
end
