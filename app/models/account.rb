class Account < ApplicationRecord
  self.inheritance_column = nil # free up the "type" column
  include Rodauth::Rails.model
  enum :status, unverified: 1, verified: 2, closed: 3

  has_many :questions, counter_cache: true, dependent: :destroy
  has_many :candies, counter_cache: true, dependent: :destroy
  has_one :profile, as: :profileable
  acts_as_voter
  acts_as_tagger
  followability
  
  def vote_weight_on(votable, vote_scope:)
    find_votes(
      votable_id: votable.id,
      votable_type: votable.class.base_class.name,
      vote_scope: vote_scope
    ).pluck(:vote_weight).first
  end

  def self.with_accounts_count
    select('accounts.*, COUNT("candies".id) AS candies_count').left_joins(:candies).group('accounts.id')
  end

  def unfollow(user)
    followerable_relationships.where(followable_id: user.id).destroy_all
  end
end
