require 'test_helper'

class TweetMailerTest < ActionMailer::TestCase
  test 'tweet' do
    mail = TweetMailer.tweet
    assert_equal 'Tweet', mail.subject
    assert_equal [ 'to@example.org' ], mail.to
    assert_equal [ 'from@example.com' ], mail.from
    assert_match 'Hi', mail.body.encoded
  end
end
