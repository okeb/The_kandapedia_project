class AddVerifiedToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :is_verified, :integer, default: 0
  end
end
