class CreateRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.references :liker, null: false, foreign_key: { to_table: :accounts }
      t.references :liked, null: false, foreign_key: { to_table: :accounts }
      t.decimal :relation_strength, null: false, default: 0.001, precision: 40, scale: 6
      t.string :details, null: true
      t.timestamps
    end

    add_index :relationships, %i[liker_id liked_id], unique: true
  end
end
