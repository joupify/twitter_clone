# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  event_type :string
#  metadata   :json
#  status     :integer
#  string     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment_id :bigint
#  like_id    :bigint
#  tweet_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_events_on_comment_id  (comment_id)
#  index_events_on_like_id     (like_id)
#  index_events_on_tweet_id    (tweet_id)
#  index_events_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (comment_id => comments.id)
#  fk_rails_...  (like_id => likes.id)
#  fk_rails_...  (tweet_id => tweets.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
