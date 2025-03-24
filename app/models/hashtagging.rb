# == Schema Information
#
# Table name: hashtaggings
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  hashtag_id :bigint           not null
#  tweet_id   :bigint           not null
#
# Indexes
#
#  index_hashtaggings_on_hashtag_id  (hashtag_id)
#  index_hashtaggings_on_tweet_id    (tweet_id)
#
# Foreign Keys
#
#  fk_rails_...  (hashtag_id => hashtags.id)
#  fk_rails_...  (tweet_id => tweets.id)
#
class Hashtagging < ApplicationRecord
  belongs_to :tweet
  belongs_to :hashtag, counter_cache: :tweets_count
end