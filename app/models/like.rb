# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tweet_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_likes_on_tweet_id              (tweet_id)
#  index_likes_on_user_id               (user_id)
#  index_likes_on_user_id_and_tweet_id  (user_id,tweet_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tweet_id => tweets.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  has_many :liking_users, through: :likes, source: :user
  validates :user_id, uniqueness: { scope: :tweet_id } # user ne peut pas liker 2 fois le meme tweet
  validate :user_cannot_like_own_tweet

  after_create :notify_tweet_owner


  after_create_commit { broadcast_like }
  after_destroy_commit { broadcast_like }


  def likes_count
    likes.count
  end

  private


  def broadcast_like
    ActionCable.server.broadcast('likes', {
      tweet_id: tweet.id,
      likes_count: tweet.likes.count,
      user_liked: user.liked_tweets.include?(tweet),
      action: persisted? ? 'like' : 'unlike'
    })
  end


  def user_cannot_like_own_tweet
    errors.add(:user, 'Vous ne pouvez pas liker votre propre tweet') if tweet.user == user
  end

   def notify_tweet_owner
    LikeNotifier.with(tweet: tweet, user: user, like: like).deliver_later(user)
   end
    


end
