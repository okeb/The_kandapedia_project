# frozen_string_literal: true

class Profile < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged
  belongs_to :profileable, polymorphic: true
  has_one_attached :avatar
  before_create :add_color

  enum :is_verified, unverified: 0, verified: 1, closed: 2, checking: 3, banned: 4
  
  scope :verified, -> { is_verified == "verified"}
  scope :blocked, -> { is_verified == "blocked"}
  
  acts_as_ordered_taggable
  acts_as_ordered_taggable_on :skills
  acts_as_tagger

  validates_uniqueness_of :username, uniqueness: { case_sensitive: false }
  validates :terms_of_service, acceptance: { message: I18n.t("activerecord.errors.models.user.attributes.terms_of_service.acceptance") }

  def avatar_thumb
    avatar.variant(resize_to_limit: [100, 100]).processed
  end

  def avatar_profile
    avatar.variant(resize_to_limit: [250, 250])&.processed
  end

  def get_initial_profile
    initials = ''
    if !lastname.nil? && !firstname.nil?
      if !lastname.empty? && !firstname.empty?
        long_name = "#{lastname} #{firstname}".split(' ')
        long_name.each { |x| initials += x[0] }
        initials = username if initials.length < 2
      else
        initials = username
      end
    else
      initials = username
    end

    initials[0..2].upcase
  end

  def add_color
    self.color = Random.bytes(3).unpack1('H*').paint.brighten(23)
  end

  private

  def set_name
    @name = if (!lastname.nil? && !lastname.empty?) || (!firstname.nil? && !firstname.empty?)
              "#{lastname} #{firstname}"
            else
              username.to_s
            end
  end
end
