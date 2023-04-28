class CreateRodauthLockout < ActiveRecord::Migration[7.0]
  def change
    # Used by the lockout feature
    create_table :account_login_failures, id: false do |t|
      t.bigint :id, primary_key: true
      t.foreign_key :accounts, column: :id
      t.integer :number, null: false, default: 1
    end
    create_table :account_lockouts, id: false do |t|
      t.bigint :id, primary_key: true
      t.foreign_key :accounts, column: :id
      t.string :key, null: false
      t.datetime :deadline, null: false
      t.datetime :email_last_sent
    end
  end
end
