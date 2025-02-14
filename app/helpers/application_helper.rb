module ApplicationHelper
    def tweet_depth(tweet, depth = 0)
      return depth if tweet.parent_id.nil?

      tweet_depth(Tweet.find(tweet.parent_id), depth + 1)
    end
end
