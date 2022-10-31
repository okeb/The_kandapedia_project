class Question < ApplicationRecord
  attribute :uuid, MySQLBinUUID::Type.new
  before_create { self.uuid = ApplicationRecord.generate_uuid }
  belongs_to :question, class_name: "Question", optional: true
  belongs_to :account

  after_create :create_slug
  before_update :update_slug

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
