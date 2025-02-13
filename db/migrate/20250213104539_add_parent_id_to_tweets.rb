class AddParentIdToTweets < ActiveRecord::Migration[8.0]
  def change
    add_column :tweets, :parent_id, :integer
  end
end
