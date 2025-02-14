class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  validates :user_id, uniqueness: { scope: :tweet_id }


  def favorited?(tweet)
    favorited_tweets.include?(tweet)
  end
end
