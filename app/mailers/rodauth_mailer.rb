# frozen_string_literal: true
class RodauthMailer < ApplicationMailer
  default :from => '"oliver" <oliver@kandapedia.com>'
  default from: 'oliver@kandapedia.com'
  def verify_account(name, account_id, key)
    @email_link = email_link(name, :verify_account, account_id, key)
    @account = find_account(name, account_id)

    mail(
      subject: rodauth(name).verify_account_email_subject,
      to: @account.email,
      from: 'oliver@kandapedia.com',
      track_opens: 'true',
      message_stream: 'outbound',
      delivery_method_options: {
        api_key: Rails.application.credentials.mailjet_api_key,
        secret_key: Rails.application.credentials.mailjet_api_key.mailjet_secret_key
      })
    # ) do |format|
    #   format.mjml
    #   format.text
    #  end
  end

  def email_auth(name, account_id, key)
    @email_link = email_link(name, :email_auth, account_id, key)
    @account = find_account(name, account_id)

    mail(
      subject: rodauth(name).email_auth_email_subject,
      to: @account.email,
      from: 'oliver@kandapedia.com',
      track_opens: 'true',
      message_stream: 'outbound',
      delivery_method_options: {
        api_key: Rails.application.credentials.mailjet_api_key,
        secret_key: Rails.application.credentials.mailjet_api_key.mailjet_secret_key
      })
    # ) do |format|
    #   format.mjml
    #   format.text
    #  end
  end

  def reset_password(name, account_id, key)
    @email_link = email_link(name, :reset_password, account_id, key)
    @account = find_account(name, account_id)

    mail(
      subject: rodauth(name).reset_password_email_subject,
      to: @account.email,
      from: 'oliver@kandapedia.com',
      track_opens: 'true',
      message_stream: 'outbound',
      delivery_method_options: {
        api_key: Rails.application.credentials.mailjet_api_key,
        secret_key: Rails.application.credentials.mailjet_api_key.mailjet_secret_key
      })
    # ) do |format|
    #   format.mjml
    #   format.text
    #  end
  end

  def verify_login_change(name, account_id, key)
    @email_link = email_link(name, :verify_login_change, account_id, key)
    @account = find_account(name, account_id)
    @new_email = @account.login_change_key.login

    mail(
      to: @new_email,
      from: 'oliver@kandapedia.com',
      subject: rodauth(name).verify_login_change_email_subject,
      track_opens: 'true',
      message_stream: 'outbound'
    )
    # ) do |format|
    #   format.mjml
    #   format.text
    #  end
  end

  def password_changed(name, account_id)
    @account = find_account(name, account_id)

    mail(
      to: @account.email,
      from: 'oliver@kandapedia.com',
      subject: rodauth(name).password_changed_email_subject,
      track_opens: 'true',
      message_stream: 'outbound'
    )
    # ) do |format|
    #   format.mjml
    #   format.text
    # end
  end

  def unlock_account(name, account_id, key)
    @email_link = email_link(name, :unlock_account, account_id, key)
    @account = find_account(name, account_id)

    mail(
      subject: rodauth(name).unlock_account_email_subject,
      to: @account.email,
      from: 'oliver@kandapedia.com',
      track_opens: 'true',
      message_stream: 'outbound',
      delivery_method_options: {
        api_key: Rails.application.credentials.mailjet_api_key,
        secret_key: Rails.application.credentials.mailjet_api_key.mailjet_secret_key
      })
    # ) do |format|
    #   format.mjml
    #   format.text
    #  end
  end

  private

  def find_account(_name, account_id)
    Account.find(account_id)
  end

  def email_link(name, action, account_id, key)
    instance = rodauth(name)
    instance.instance_variable_set(:@account, { id: account_id })
    instance.instance_variable_set(:"@#{action}_key_value", key)
    instance.public_send(:"#{action}_email_link")
  end

  def rodauth(name)
    RodauthApp.rodauth(name).allocate
  end
end
