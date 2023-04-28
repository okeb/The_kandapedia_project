# frozen_string_literal: true

class KandyComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(kandy:)
    @kandy = kandy
  end

end
