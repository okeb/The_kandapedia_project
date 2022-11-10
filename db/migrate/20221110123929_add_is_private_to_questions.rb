class AddIsPrivateToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :is_private, :boolean, default: false
  end
end
