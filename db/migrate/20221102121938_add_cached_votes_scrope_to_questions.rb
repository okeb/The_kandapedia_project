class AddCachedVotesScropeToQuestions < ActiveRecord::Migration[7.0]
  def change
    change_table :questions do |t|
      # t.integer :cached_scoped_bookmark_votes_total, default: 0
      # t.integer :cached_scoped_bookmark_votes_score, default: 0
      # t.integer :cached_scoped_bookmark_votes_up, default: 0
      # t.integer :cached_scoped_bookmark_votes_down, default: 0
      # t.integer :cached_weighted_bookmark_score, default: 0
      # t.integer :cached_weighted_bookmark_total, default: 0
      # t.float :cached_weighted_bookmark_average, default: 0.0

      # t.integer :cached_scoped_readlist_votes_total, default: 0
      # t.integer :cached_scoped_readlist_votes_score, default: 0
      # t.integer :cached_scoped_readlist_votes_up, default: 0
      # t.integer :cached_scoped_readlist_votes_down, default: 0
      # t.integer :cached_weighted_readlist_score, default: 0
      # t.integer :cached_weighted_readlist_total, default: 0
      # t.float :cached_weighted_readlist_average, default: 0.0

      t.integer :cached_scoped_appreciation_votes_total, default: 0
      t.integer :cached_scoped_appreciation_votes_score, default: 0
      t.integer :cached_scoped_appreciation_votes_up, default: 0
      t.integer :cached_scoped_appreciation_votes_down, default: 0
      t.integer :cached_weighted_appreciation_score, default: 0
      t.integer :cached_weighted_appreciation_total, default: 0
      t.float :cached_weighted_appreciation_average, default: 0.0

      # Uncomment this line to force caching of existing scoped votes
      # Post.find_each { |p| p.update_cached_votes("subscribe") }
    end
  end
end
