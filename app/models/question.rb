class Question < ApplicationRecord
  attribute :uuid, MySQLBinUUID::Type.new
  before_create { self.uuid = ApplicationRecord.generate_uuid }
  after_create :create_slug
  before_update :update_slug
  belongs_to :question, class_name: "Question", optional: true
  belongs_to :account

  acts_as_taggable_on :tags
  acts_as_votable cacheable_strategy: :update_columns

  is_impressionable :counter_cache => true, :column_name => :views_count, :unique => :session_hash


  scope :desc, -> { order(created_at: :desc) }

  def to_param
    slug
  end 

  private

  def create_slug
    update_slug
    save!
  end

  def update_slug
    self.slug = [title&.parameterize, uuid].compact.join("-")
  end


end
