class Question < ApplicationRecord
    attribute :uuid, MySQLBinUUID::Type.new
    before_create { self.uuid = ApplicationRecord.generate_uuid }
    belongs_to :account
    # validates :body, presence: true
end
