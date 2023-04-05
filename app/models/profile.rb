class Profile < ApplicationRecord
  belongs_to :account
  has_one_attached :avatar
  before_create :add_color

  acts_as_ordered_taggable
  acts_as_ordered_taggable_on :skills
  acts_as_tagger
  
  validates_uniqueness_of :username, uniqueness: { case_sensitive: false }
  validates :terms_of_service, acceptance: { message: 'must be abided' }

  def avatar_thumb
    self.avatar.variant(resize_to_limit: [100, 100]).processed
  end
  
  def avatar_profile
    if !self.avatar.variant(resize_to_limit: [250, 250]).nil?
      self.avatar.variant(resize_to_limit: [250, 250]).processed
    end
  end

  def get_initial_profile
    initials = ""
    if !lastname.nil? && !self.firstname.nil?
      if !self.lastname.empty? && !self.firstname.empty?
        long_name = (self.lastname + " " + self.firstname).split(' ')
        long_name.each{ |x|  initials += x[0]}
        if initials.length < 2
          initials = self.username
        end
      else
        initials = self.username
      end
    end


    initials[0..2].upcase
  end

  def add_color
    self.color = Random.bytes(3).unpack1('H*').paint.brighten(23) 
  end
end
