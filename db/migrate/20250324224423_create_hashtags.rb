class CreateHashtags < ActiveRecord::Migration[8.0]
  def change
    create_table :hashtags do |t|
      t.string :name
      t.integer :tweets_count, default: 0

      t.timestamps
    end
    add_index :hashtags, :name
  end
end
