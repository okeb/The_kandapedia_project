class AddNoteToCandies < ActiveRecord::Migration[7.0]
  def change
    add_column :candies, :note, :decimal, precision: 49, scale: 7, after: :view, default: 1
    add_column :candies, :boost, :integer, after: :note, default: 0
  end
end
