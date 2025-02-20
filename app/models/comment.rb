# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tweet_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_tweet_id  (tweet_id)
#  index_comments_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (tweet_id => tweets.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :tweet, counter_cache: :comments_count
  belongs_to :user, counter_cache: :comments_count

  validates :content, presence: true

  after_create :notify_tweet_owner

  private
  
  def notify_tweet_owner
    CommentNotifier.with(tweet: tweet, user: user, comment: comment).deliver_later(user)
  end
  
  


end
