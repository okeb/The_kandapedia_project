class AddLikesToCandies < ActiveRecord::Migration[7.0]
  def change
    add_column :candies, :like, :integer,default: 0, after: :view
  end
end
