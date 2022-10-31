class AddQuestionsCountToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :questions_count, :integer, default: 0, null: false
  end
end
