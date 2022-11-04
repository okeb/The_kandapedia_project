class Account < ApplicationRecord
  include Rodauth::Rails.model
  enum :status, unverified: 1, verified: 2, closed: 3

  has_many :questions, counter_cache: true
  has_one :profile
  acts_as_voter

  def vote_weight_on(votable, vote_scope:)
    find_votes(
      votable_id: votable.id, 
      votable_type: votable.class.base_class.name, 
      vote_scope: vote_scope
    ).pluck(:vote_weight).first
  end
end
