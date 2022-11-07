class Profile < ApplicationRecord
  belongs_to :account
  has_one_attached :avatar
  before_create :add_color

  acts_as_ordered_taggable
  acts_as_ordered_taggable_on :skills

  def avatar_thumb
    self.avatar.variant(resize_to_limit: [100, 100]).processed
  end
  
  def avatar_profile
    self.avatar.variant(resize_to_limit: [250, 250]).processed
  end

  def get_initial_profile
    initials = ""
    long_name = (self.lastname + " " + self.firstname).split(' ')

    long_name.each{ |x|  initials += x[0]}

    initials[0..2].upcase
  end

  def add_color
    self.color = Random.bytes(3).unpack1('H*').paint.brighten(23) 
  end
end
