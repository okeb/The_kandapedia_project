class AddNoteToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :activity_rate, :decimal, precision: 10, scale: 2, after: :password_hash, default: 1
  end
end
