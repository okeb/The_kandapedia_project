class AddImageDataToCandies < ActiveRecord::Migration[7.0]
  def change
    add_column :candies, :image_data, :text
  end
end
