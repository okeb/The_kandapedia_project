class CreateCandies < ActiveRecord::Migration[7.0]
  def change
    create_table :candies do |t|
      t.string :body, limit: 444
      t.integer :scope, default: 0
      t.integer :position, default: 1
      t.integer :view, default: 0
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
