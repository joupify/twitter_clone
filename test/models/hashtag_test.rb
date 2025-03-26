# == Schema Information
#
# Table name: hashtags
#
#  id           :bigint           not null, primary key
#  name         :string
#  tweets_count :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_hashtags_on_name  (name)
#
require "test_helper"

class HashtagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
