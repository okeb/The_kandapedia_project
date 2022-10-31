class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.binary :uuid, limit: 16
      t.string :title
      t.string :slug
      t.text :body
      t.integer :note, default: 0
      t.integer :views_count, default: 0
      t.integer :position
      t.boolean :is_published, default: false
      t.references :parent, null: true, foreign_key: { to_table: :questions }

      t.timestamps
    end
  end
end
