class Relationship < ApplicationRecord
  self.table_name = "relationships"
  belongs_to :liker, class_name: "Account"
  belongs_to :liked, class_name: "Account"
end