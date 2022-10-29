class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :topic
      t.text :body
      t.integer :note, default: 0
      t.boolean :is_published, default: false

      t.timestamps
    end
  end
end
