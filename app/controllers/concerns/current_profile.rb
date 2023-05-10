# frozen_string_literal: true
module CurrentProfile
  extend ActiveSupport::Concern

  included do
    before_action :set_current_profile
  end

  private

  def set_current_profile
    @current_profile ||= if rodauth.prefix === '/user'
                           Profile.find_by(profileable_id: current_account.id, profileable_type: 'Account')
                         else
                           Profile.find_by(profileable_id: current_account.id, profileable_type: 'AdminAccount')
                         end
    session[:current_profile_id] = @current_profile.id if @current_profile
  end

  def current_profile
    @current_profile ||= Profile.find_by(id: session[:current_profile_id])
  end
end
