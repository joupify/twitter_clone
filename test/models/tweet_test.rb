# == Schema Information
#
# Table name: tweets
#
#  id              :bigint           not null, primary key
#  comments_count  :integer          default(0), not null
#  content         :text
#  favorites_count :integer          default(0), not null
#  likes_count     :integer          default(0), not null
#  retweets_count  :integer          default(0), not null
#  views_count     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_id       :integer
#  user_id         :bigint           not null
#
# Indexes
#
#  index_tweets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
