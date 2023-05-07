# frozen_string_literal: true

class KandyComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(kandy:, current_account:, rodauth:)
    @kandy = kandy
    @current_account = current_account
    @rodauth = rodauth
  end

end
