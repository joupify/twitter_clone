class CreateHashtaggings < ActiveRecord::Migration[8.0]
  def change
    create_table :hashtaggings do |t|
      t.references :tweet, null: false, foreign_key: true
      t.references :hashtag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
