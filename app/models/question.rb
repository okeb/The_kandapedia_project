class Question < ApplicationRecord
    belongs_to :account
    # validates :body, presence: true
end
