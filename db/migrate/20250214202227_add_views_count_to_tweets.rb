class AddViewsCountToTweets < ActiveRecord::Migration[8.0]
  def change
    add_column :tweets, :views_count, :integer
  end
end
