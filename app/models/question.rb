class Question < ApplicationRecord
    attribute :uuid, MySQLBinUUID::Type.new
    belongs_to :account
    # validates :body, presence: true
end
