class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  has_many :liking_users, through: :likes, source: :user
  validates :user_id, uniqueness: { scope: :tweet_id }

  after_create_commit { broadcast_like }
  after_destroy_commit { broadcast_like }


  def likes_count
    likes.count
  end

  private

  def broadcast_like
    ActionCable.server.broadcast("likes", {
      tweet_id: tweet.id,
      likes_count: tweet.likes.count,
      user_liked: user.liked_tweets.include?(tweet),
      action: persisted? ? "like" : "unlike"
    })
  end
end