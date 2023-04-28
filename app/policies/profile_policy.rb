class ProfilePolicy < ApplicationPolicy
  attr_reader :profile

  def initialize(account, profile)
    @account = account
    @profile = profile
  end

  def new?
    @account != nil
  end

  def edit?
    (@account != nil) && @profile.profileable_id == @account.id
  end
  
  def update?
    (@account != nil) && @profile.profileable_id == @account.id
  end
end
