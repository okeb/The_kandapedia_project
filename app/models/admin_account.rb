class AdminAccount < ApplicationRecord
  self.inheritance_column = nil # free up the "type" column
  include Rodauth::Rails.model
  enum :status, unverified: 1, verified: 2, closed: 3
  
  has_one :profile, as: :profileable
end
