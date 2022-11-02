class Account < ApplicationRecord
  include Rodauth::Rails.model
  enum :status, unverified: 1, verified: 2, closed: 3

  has_many :questions, counter_cache: true
  has_one :profile
  acts_as_voter
end
