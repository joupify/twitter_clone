class AddCountersToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :likes_count, :integer
    add_column :users, :comments_count, :integer
    add_column :users, :tweets_count, :integer
  end
end
