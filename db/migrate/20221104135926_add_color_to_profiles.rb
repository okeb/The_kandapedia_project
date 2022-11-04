class AddColorToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :color, :string
  end
end
