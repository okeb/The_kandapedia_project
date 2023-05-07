class Candy < ApplicationRecord
  belongs_to :account
  belongs_to :question, class_name: "Question", optional: true
  validates :body, presence: true, length: { maximum: 400 }
  validates :scope, presence: true
  include ImageUploader::Attachment(:image)

  after_create_commit :notify_friends

  has_noticed_notifications model_name: 'Notification'
  has_many :notifications, through: :account, dependent: :destroy

  enum :scope, none_scope: 0, public_scope: 1, protected_scope: 2, private_scope: 3, deleted_scope: 4

  scope :desc, -> { order(created_at: :desc) }


  def notify_friends
    @account = Account.find(self.account.id)
    @friends = @account.followers
    @friends.each do |friend|
      KandyNotification.with(candy: self, account: friend).deliver_later(friend)
    end
  end
end
