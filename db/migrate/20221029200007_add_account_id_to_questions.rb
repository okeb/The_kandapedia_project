class AddAccountIdToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions, :account, null: false, foreign_key: true
  end
end
