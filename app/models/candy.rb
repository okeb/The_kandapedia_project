class Candy < ApplicationRecord
  belongs_to :account
  belongs_to :question, class_name: "Question", optional: true
  validates :body, presence: true, length: { maximum: 400 }
  validates :scope, presence: true
  
  enum :scope, none_scope: 0, public_scope: 1, protected_scope: 2, private_scope: 3, deleted_scope: 4

  scope :desc, -> { order(created_at: :desc) }
end
