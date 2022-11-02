class AddCachedVotesScropeToQuestions < ActiveRecord::Migration[7.0]
  def change
    change_table :questions do |t|
      t.integer :cached_scoped_votes_total, default: 0
      t.integer :cached_scoped_votes_score, default: 0
      t.integer :cached_scoped_votes_up, default: 0
      t.integer :cached_scoped_votes_down, default: 0
      t.integer :cached_weighted_score, default: 0
      t.integer :cached_weighted_total, default: 0
      t.float :cached_weighted_average, default: 0.0

      # Uncomment this line to force caching of existing scoped votes
      # Post.find_each { |p| p.update_cached_votes("subscribe") }
    end
  end
end
