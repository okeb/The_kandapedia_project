class CreateRodauthEmailAuth < ActiveRecord::Migration[7.0]
  def change
    # Used by the email auth feature
    create_table :account_email_auth_keys, id: false do |t|
      t.bigint :id, primary_key: true
      t.string :key, null: false
      t.datetime :deadline, null: false
      t.datetime :email_last_sent, null: false, default: -> { "CURRENT_TIMESTAMP(6)" }
    end
  end
end
