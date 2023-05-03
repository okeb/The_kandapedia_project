class AddTypesToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :type, :string, null: false, default: 'user'
    add_column :admin_accounts, :type, :string, null: false, default: 'user'
  end
end
