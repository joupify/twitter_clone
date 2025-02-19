class ChangeNullConstraintForTweetIdInEvents < ActiveRecord::Migration[8.0]
  def change
    change_column_null :events, :tweet_id, true

  end
end
