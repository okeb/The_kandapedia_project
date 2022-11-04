class Profile < ApplicationRecord
  belongs_to :account
  has_one_attached :avatar

  def avatar_thumb
    self.avatar.variant(resize_to_limit: [100, 100])
  end
  
  def avatar_profile
    self.avatar.variant(resize_to_limit: [250, 250])
  end

  def get_initial_profile
    initials = ""
    long_name = (self.lastname + " " + self.firstname).split(' ')

    long_name.each{ |x|  initials += x[0]}

    initials[0..2].upcase
  end
end
