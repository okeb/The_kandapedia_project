class AddUuidColumnToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :uuid, :binary, limit: 16
  end
end
