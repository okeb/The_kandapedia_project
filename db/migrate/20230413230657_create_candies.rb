class CreateCandies < ActiveRecord::Migration[7.0]
  def change
    create_table :candies do |t|
      t.binary :uuid, limit: 16
      t.string :body, limit: 444
      t.integer :scope, default: 0
      t.references :parent, null: true, foreign_key: { to_table: :candies }
      t.integer :position, default: 0
      t.integer :view, default: 0
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
