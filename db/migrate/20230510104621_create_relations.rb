class CreateRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :relations do |t|
      t.references :liker, null: false, foreign_key: { to_table: :account }
      t.references :liked, null: false, foreign_key: { to_table: :account }
      t.decimal :relation_strength, null: false
      t.timestamps
    end

    add_index :relations, %i[liker_id liked_id], unique: true
  end
end