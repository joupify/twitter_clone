class AddCounterToTweets < ActiveRecord::Migration[8.0]
  def change
    add_column :tweets, :likes_count, :integer, default: 0, null: false
    add_column :tweets, :comments_count, :integer, default: 0, null: false
    add_column :tweets, :favorites_count, :integer, default: 0, null: false
  end
end
