# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
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

  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy

  validates :content, presence: true

  after_create :notify_tweet_owner
  after_destroy :update_counter


  private

  def notify_tweet_owner
    tweet.user.notify_user(:comment, self)
  end

  def update_counter
    tweet.decrement!(:comments_count) if tweet.present?
  end
end
