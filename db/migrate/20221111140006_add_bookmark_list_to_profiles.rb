class AddBookmarkListToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :bookmark_list, :json
    add_column :profiles, :readlist_list, :json
  end
end
