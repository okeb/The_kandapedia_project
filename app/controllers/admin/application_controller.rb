
class Admin::ApplicationController < ApplicationController
  layout 'admin'

  def current_account
    rodauth(:admin).rails_account
  end
end