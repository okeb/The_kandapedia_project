class AddLikesCountToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :likes_count, :integer, default: 0
  end
end
